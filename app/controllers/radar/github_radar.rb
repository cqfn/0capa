# frozen_string_literal: false

require 'json'
require 'git'
require 'fileutils'
require 'socket'

require_relative 'radar_base_controller'

class GithubRadar < RadarBaseController
  SOURCE = 'github'.freeze
  @@Tokens = nil
  @@call_count = 0
  @@External_threar_stop = false
  @@Is_active_instance = false

  def getNextToken
    @@call_count += 1
    next_token_index = (@@call_count % @@Tokens.length)
    @@Tokens[next_token_index].token
  end

  def initialize
    puts 'initialize class GithubRadar'
    Initialize(SOURCE)
    get_tokens
  end

  def start_radar
    puts 'initializing radar...'
    @@External_threar_stop = false
    if @@Is_active_instance == false
      puts 'There is no active instance, setting up a new one...'
      @@Is_active_instance = true
      loop do
        check_new_invitations
        puts 'Processing new invitations...'
        _limit = getQueueCounter
        if _limit.positive?
          [*1.._limit].each do |_p|
            puts "projects that need to analize #{_limit}"
            check_repos_update
            sleep(60)
            next unless @@External_threar_stop == true

            @@Is_active_instance = false
            return true
          end
        else
          sleep(2.hours)
        end
        next unless @@External_threar_stop == true

        puts 'signal stop catched..'
        @@Is_active_instance = false
        return true
      end
    else
      puts 'There is already an instance runing...'
      false
    end
  end

  def stop_radar
    @@External_threar_stop = true
    puts 'Signal stop sent...'
  end

  def get_tokens
    return unless @@Tokens.nil?

    puts 'Getting token list!!'
    @@Tokens = TomTokensQueue.where(source: 'github')
  end

  def getTokenList
    TomTokensQueue.where(source: 'github')
  end

  def check_new_invitations
    puts 'starting process check_new_invitations...'
    settings = TomSetting.where(agentname: 'github').order(node_name: :asc).first
    response = HTTP[accept: settings.content_type, Authorization: "token #{settings.apisecret}"].get(
      settings.invitations_endpoint, json: {}
    )
    if response.code == 200
      invitations = JSON.parse(response)
      invitations.each do |invitation|
        next unless invitation['expired'] != true

        project = TomProject.new(
          name: invitation['repository']['name'],
          repo_fullname: invitation['repository']['full_name'],
          repoid: invitation['repository']['id'],
          repo_url: invitation['repository']['url'],
          invitation_id: invitation['id'],
          inviter_login: invitation['inviter']['login'],
          permissions: invitation['permissions'],
          is_private: invitation['repository']['private'] == true ? 'True' : 'False',
          owner_login: invitation['repository']['owner']['login'],
          source: SOURCE,
          isactive: 'Y'
        )
        accept_url = settings.invitations_accept_endpoint.sub! '#invitation_id', invitation['id'].to_s

        invitation_response = HTTP[accept: settings.content_type, Authorization: "token #{settings.apisecret}"].patch(
          accept_url, json: {}
        )
        puts "invitation_response -> #{invitation_response.code}"

        info_url_template = settings.repos_info_url.dup

        puts "info_url_template -> #{info_url_template}"

        request_url = info_url_template.sub! '#repo_fullname', invitation['repository']['full_name']

        puts 'welcomeResponse'
        puts request_url

        issue_body =
          "🥳TOM has started processing your repository. \nSeat & drink some coffee ☕ and wait, in just a couple of minutes the @0capa-demo bot will open the capa suggestion issues for this particular project. You can also visit https://0capa.ru/ 🥸 to read detailed info."

        issue_body.sub! '#capa-1', Capa.order('RANDOM()').first.description
        issue_body.sub! '#capa-2', Capa.order('RANDOM()').first.description
        issue_body.sub! '#capa-3', Capa.order('RANDOM()').first.description
        issue_body.sub! '#capa-4', Capa.order('RANDOM()').first.description
        issue_body.sub! '#capa-5', Capa.order('RANDOM()').first.description

        welcomeResponse = HTTP[accept: 'application/vnd.github.v3+json', Authorization: "token #{getNextToken}"].post(
          "#{request_url}/issues", json: { title: '💥Welcome issue over repo💥', body: issue_body }
        )
        puts JSON.pretty_generate(welcomeResponse.parse)
        if invitation_response.code == 204
          info_url_template = settings.repos_info_url.dup
          puts "info_url_template -> #{info_url_template}"
          if invitation_response.code == 200
            repo = JSON.parse(response)
            project.repo_created_at = DateTime.parse(repo['created_at'])
          else
            puts JSON.pretty_generate(response.parse)
          end
          project.save
        else
          puts 'there was an error accepting the invitation...'
          return false
        end
      end
    else
      puts JSON.pretty_generate(response.parse)
      return false
    end
    true
  rescue StandardError => e
    puts e
    false
  end

  def euclideanDistance(p, q)
    p = [p].flatten
    q = [q].flatten
    result = Math.sqrt(p.zip(q).inject(0) { |sum, coord| sum + (coord.first - coord.last)**2 })
    # puts "EUCLIDIAN DISTANCE data: #{p}, consensus: #{q} => #{result}"
    result
  end

  def getQueueCounter
    TomProject.where(total_analyse_state: 'N').count
  end

  def check_repos_update
    repos_for_preliminary_analyse = TomProject.where(total_analyse_state: 'N').order('updated_at DESC').first(5)

    puts "REPOS FOR PREMILINARY ANALYSE : #{repos_for_preliminary_analyse.count}"

    if repos_for_preliminary_analyse.length.positive?
      repos_for_preliminary_analyse.each do |repo|
        # repo.update(total_analyse_state: 'Y')
        # repo.save
        puts 'Starting proceed preliminary analyse.. '
        puts repo.repo_url
        proceed_preliminary_analyse repo.repo_url
        puts 'Ending proceed preliminary analyse.. '
      end
    else
      repos_for_ordinary_analyse = TomProject.where("source = :source and (total_analyse_state ='Y') ", {
                                                      source: SOURCE
                                                    })
      if repos_for_ordinary_analyse.length.positive?
        repos_for_preliminary_analyse.each do |repo|
          proceed_ordinary_analyse(repo.repo_url, repo.last_commit_analyse_hash)
        end

      end
    end
  end

  def proceed_ordinary_analyse(repo_url, _last_commit_hash)
    settings = TomSetting.where(agentname: 'github').order(node_name: :asc).first
    commits_history_response = HTTP[accept: settings.content_type, Authorization: "token #{getNextToken}"].get(
      "#{repo_url}/commits", json: {}
    )
    if commits_history_response.code == 200
      commits_history = JSON.parse(commits_history_response)
      commits_history.each do |commit|
      end

    else
      puts JSON.pretty_generate(response.parse)
    end
  end

  def proceed_preliminary_analyse(repo_url)
    # puts 'Starting.. '
    settings = TomSetting.where(agentname: 'github').order(node_name: :asc).first
    # puts "proceed_preliminary_analyse: #{repo_url}"
    commits_history_response = HTTP[accept: settings.content_type, Authorization: "token #{getNextToken}"].get(
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
        details_commits_response = HTTP[accept: settings.content_type, Authorization: "token #{getNextToken}"].get(
          url, json: {}
        )
        details = JSON.parse(details_commits_response)
        commit_diff.push(details['stats']['total'])
        commit_additions.push(details['stats']['additions'])
        commit_deletions.push(details['stats']['deletions'])

        windows.each do |key, value|
          next unless (index % key).zero? && index.positive?

          # puts 'Generating....'
          value.each do |pattern|
            metrics = []

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

            # puts 'Generated Capa'

            Capa.where(pattern_id: pattern.id).all.each do |capa|
              generated = GeneratedCapa.new(
                title: capa.title,
                body: capa.description,
                mode: 'ML',
                status: 'N',
                repo_name: repo_url
              )
              generated.save
              # puts generated.inspect
            end
          end
        end
      end

    else
      puts JSON.pretty_generate(response.parse)
    end
  end
end
