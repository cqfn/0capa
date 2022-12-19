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

  def initialize
    puts 'initialize class GithubRadar'
    Initialize(SOURCE)
    get_tokens
  end

  def start_radar
    puts 'initializing radar...'
    @@External_threar_stop = false
    if @@Is_active_instance == false
      PrettyLogger.highlight("There is no active instance, setting up a new one...")
      @@Is_active_instance = true
      loop do
        check_new_invitations
        PrettyLogger.highlight("Processing new invitations...")
        _limit = getQueueCounter # count of projects that was not analyzed for the last 15 days
        if _limit.positive?
          [*1.._limit].each do |p|
            PrettyLogger.highlight("Invitations for now #{_limit}")
            check_repos_update
            sleep(2)
            next unless @@External_threar_stop == true
            @@Is_active_instance = false
            return true
          end
        else
          sleep(60)
        end
        next unless @@External_threar_stop == true
        PrettyLogger.highlight("signal stop catched..")
        @@Is_active_instance = false
        return true
      end
    else
      PrettyLogger.highlight("There is already an instance runing...")
      false
    end
  end

  def stop_radar
    @@External_threar_stop = true
    PrettyLogger.highlight("Signal stop sent...")
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
    settings = TomSetting.where('agentname = github',).order(node_name: :asc).first
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

        capas = [
          'review and improve staff training procedures [#TOM-C001]',
          'replan project and re-estimate targets [#TOM-C002]',
          'review and improve estimating procedures [#TOM-C003]',
          'review and improve project working procedures [#TOM-C004]',
          'if the scope of the project has been underestimated, obtain more experienced staff [#TOM-C005]',
          'if the scope has been overestimated, release experienced staff to other projects [#TOM-C006]',
          'stop current work and revert to activities of preceding stage [#TOM-C007]',
          'extend activities of previous stage into current stage, replanning effort and work assignment [#TOM-C008]',
          'extend timescales for testing and debugging current stage because of anticipated additional latent faults from previous stage [#TOM-C009]',
          'review and improve criteria for entry to, and exit from, stages and activities [#TOM-C010]',
          'redesign the module into smaller components [#TOM-C011]',
          'extend the timescales for testing the module [#TOM-C012]'
        ]

        issue_body =
          "🥳TOM has started processing your repository. \nSeat & drink some coffee ☕ and wait, in just a couple of minutes the @0capa-demo bot will open the capa suggestion issues for this particular project. You can also visit https://0capa.ru/ 🥸 to read detailed info."

        issue_body.sub! '#capa-1', capas.sample
        issue_body.sub! '#capa-2', capas.sample

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
          puts 'there was an error accepting the invitaion...'
          return false
          # raise "It was a error accepting collaboration invitation."
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
    p, q = [p].flatten, [q].flatten
    sqrt(p.zip(q).inject(0) { |sum, coord| sum + (coord.first - coord.last) ** 2 })
  end

  def getQueueCounter
    project_count = TomProject.where("source = github and node_name is null and  (last_scanner_date is null or not( last_scanner_date between (now() - INTERVAL '15 DAY') and now())) and (status ='W' or status is null) ",).count
    project_count
  end

  def check_repos_update
    repos_for_preliminary_analyse = TomProject.where("source = :source and (total_analyse_state ='N') ", {
      source: SOURCE
    })

    PrettyLogger.highlight("repos_for_preliminary_analyse #{repos_for_preliminary_analyse}")

    if repos_for_preliminary_analyse.length.positive?
      repos_for_preliminary_analyse.update(total_analyse_state: 'Y')
      repos_for_preliminary_analyse.save
      repos_for_preliminary_analyse.each do |repo|
        PrettyLogger.highlight("Starting proceed preliminary analyse.. ")
        proceed_preliminary_analyse(repo.repo_url)
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

    def proceed_ordinary_analyse(repo_url, last_commit_hash)
      settings = TomSetting.where('agentname = github',).order(node_name: :asc).first
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

    def sliding_window

    end

    def proceed_preliminary_analyse(repo_url)
      settings = TomSetting.where('agentname = github',).order(node_name: :asc).first
      commits_history_response = HTTP[accept: settings.content_type, Authorization: "token #{getNextToken}"].get(
        "#{repo_url}/commits", json: {}
      )
      PrettyLogger.highlight("commits_history_response #{commits_history_response}")
      commits = []
      if commits_history_response.code == 200
        commits_history = JSON.parse(commits_history_response)
        commits_history.each do |commit|
          commits.push(commit['url'])
        end
        PrettyLogger.highlight("commits #{commits}")
        commits.each_with_index do |url, index|
          PrettyLogger.highlight("STEP: #{index} -- commit_diff #{commit_diff}")
          PrettyLogger.highlight("STEP: #{index} -- commit_additions #{commit_additions}")
          PrettyLogger.highlight("STEP: #{index} -- commit_deletions #{commit_deletions}")
          commit_diff = []
          commit_additions = []
          commit_deletions = []
          details_commits_response = HTTP[accept: settings.content_type, Authorization: "token #{getNextToken}"].get(
            url, json: {}
          )
          if index % 14 < 14
            PrettyLogger.highlight("Slide window////--")
            commit_diff.push(details_commits_response['stats']['total'])
            commit_additions.push(details_commits_response['stats']['additions'])
            commit_deletions.push(details_commits_response['stats']['deletions'])
          else
            pattern0 = Pattern.where('id = 0') # total_added pattern
            pattern1 = Pattern.where('id = 1') # total_changed_pattern
            pattern2 = Pattern.where('id = 2') # total removed pattern
            if euclideanDistance(commit_additions, pattern0.consensus_pattern) <= pattern0.threshold
              PrettyLogger.highlight("GeneratedCapa.new(")
              capa = GeneratedCapa.new(
                title: 'For current progress suggested CAPA0',
                body: 'Consider code style checking. Run linter',
                status: 'N'
              )
              capa.save
            end
            if euclideanDistance(commit_diff, pattern1.consensus_pattern) <= pattern1.threshold
              PrettyLogger.highlight("GeneratedCapa.new(")
              capa = GeneratedCapa.new(
                title: 'For current progress suggested CAPA1',
                body: 'The high probability of bugs within the new code. Increase test coverage',
                status: 'N'
              )
              capa.save
            end
            if euclideanDistance(commit_deletions, pattern2.consensus_pattern) <= pattern2.threshold
              PrettyLogger.highlight("GeneratedCapa.new(")
              capa = GeneratedCapa.new(
                title: 'For current progress suggested CAPA0',
                body: 'Consider code style checking. Run linter',
                status: 'N'
              )
              capa.save
            end
            commit_diff.clear
            commit_additions.clear
            commit_deletions.clear
          end

        end

      else
        puts JSON.pretty_generate(response.parse)
      end
    end

    def getNextToken
      @@call_count += 1
      next_token_index = (@@call_count % @@Tokens.length)
      @@Tokens[next_token_index].token
    end
  end
end
