# frozen_string_literal: true

class CheckReposUpdateJob < ApplicationJob
  queue_as :default

  after_perform do |job|
    self.class.set(wait: 2.hours).perform_later(*job.arguments)
  end

  def euclideanDistance(p, q)
    p = [p].flatten
    q = [q].flatten
    Math.sqrt(p.zip(q).inject(0) { |sum, coord| sum + (coord.first - coord.last) ** 2 })
    # puts "EUCLIDIAN DISTANCE data: #{p}, consensus: #{q} => #{result}"
  end

  def perform(*_args)
    _limit = getQueueCounter

    return unless _limit.positive?

    [*1.._limit].each do |_p|
      puts "projects that need to be analyzed #{_limit}"
      generate_capas
    end
  end

  def getQueueCounter
    TomProject.where(total_analyse_state: 'N').count
  end

  def ml_based_generation(project)
    project.update(total_analyse_state: 'Y')
    project.save
    puts 'Starting proceed preliminary analyse.. '
    puts project.repo_url
    proceed_preliminary_analyse project.repo_url
    puts 'Ending proceed preliminary analyse.. '
  end

  def random_based_generation(project)
    capa = Capa.where(pattern_id: 0).order('RANDOM()').first
    generated = GeneratedCapa.new(
      title: capa.title,
      body: capa.description,
      mode: 'Random',
      status: 'N',
      repo_name: project.repo_url
    )
    generated.save
  end

  def generate_capas
    TomProject.where(source: 'github').each do |project|
      puts "generate_capas: PROJECT MODE #{project.mode}"
      
      if project.mode == 'ML'
        puts 'generate_capas: ML MODE'
        ml_based_generation(project) if project.total_analyse_state == 'N'
      else
        puts 'generate_capas: RANDOM MODE'
        random_based_generation(project)
      end
    end
  end

  def proceed_ordinary_analyse(repo_url, _last_commit_hash)
    settings = TomSetting.where(agentname: 'github').order(node_name: :asc).first
    commits_history_response = HTTP[accept: settings.content_type, Authorization: "token #{TomTokensQueue.where(source: 'github').first.token}"].get(
      "#{repo_url}/commits", json: {}
    )
    if commits_history_response.code == 200
      commits_history = JSON.parse(commits_history_response)
      commits_history.each do |commit|
      end

    else
      puts JSON.pretty_generate(commits_history_response.parse)
    end
  end

  def proceed_preliminary_analyse(repo_url)
    # puts 'Starting.. '
    settings = TomSetting.where(agentname: 'github').order(node_name: :asc).first
    # puts "proceed_preliminary_analyse: #{repo_url}"
    commits_history_response = HTTP[accept: settings.content_type, Authorization: "token #{TomTokensQueue.where(source: 'github').first.token}"].get(
      "#{repo_url}/commits", json: {}
    )
    # puts "commits_history_response code : #{commits_history_response.code}"
    commits = []
    if commits_history_response.code == 200
      commits_history = JSON.parse(commits_history_response)
      commits_history.each do |commit|
        commits.push(commit['url'])
      end
      commit_diff = []
      commit_additions = []
      commit_deletions = []
      # puts "commits #{commits.length}"
      return if commits.length < 20

      windows = {}
      Pattern.all.each do |pattern|
        if windows.key?(pattern.window)
          windows[pattern.window].push(pattern)
        else
          windows[pattern.window] = [pattern]
        end
      end
      commits.each_with_index do |url, index|
        details_commits_response = HTTP[accept: settings.content_type, Authorization: "token #{TomTokensQueue.where(source: 'github').first.token}"].get(
          url, json: {}
        )
        details = JSON.parse(details_commits_response)
        commit_diff.push(details['stats']['total'])
        commit_additions.push(details['stats']['additions'])
        commit_deletions.push(details['stats']['deletions'])

        windows.each do |key, value|
          next unless (index % key).zero? && index.positive?

          value.each do |pattern|
            metrics = case pattern.metrics
                      when :total_diff
                        commit_diff
                      when :added_lines
                        commit_additions
                      else
                        commit_deletions
                      end

            metrics = metrics.slice(index - key, key)

            next unless euclideanDistance(metrics, pattern.consensus_pattern) <= 200

            Capa.where(pattern_id: pattern.id).all.each do |capa|
              generated = GeneratedCapa.new(
                title: capa.title,
                body: capa.description,
                mode: 'ML',
                status: 'N',
                repo_name: repo_url
              )
              generated.save
            end
          end
        end
      end

    else
      puts JSON.pretty_generate(commits_history_response.parse)
    end
  end
end
