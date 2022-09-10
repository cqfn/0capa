# frozen_string_literal: true

# TODO: implement the class methods
require 'json'
require_relative 'radar_base_controller'

class GitlabRadar < RadarBaseController
  SOURCE = 'gitlab'
  @@tokens = nil
  @@call_count = 0
  @@External_threar_stop = false
  @@Is_active_instance = false

  def initialize
    puts 'initialize class GithubRadar'
    Initialize(SOURCE)
    get_tokens
  end

  def check_new_invitations
    puts 'starting process check_new_invitations...'
    host = Socket.gethostname
    puts "SOURCE -> #{SOURCE}"
    puts "host -> #{host}"
    settings = TomSetting.where('agentname = :agentname and (node_name = :host or node_name is null) ', {
                                  agentname: SOURCE,
                                  host: host
                                }).order(node_name: :asc).first

    response = HTTP["PRIVATE-TOKEN": settings.apisecret.to_s].get(
      settings.invitations_endpoint, json: {}
    )
    # puts JSON.pretty_generate(JSON.parse(response))
    if response.code == 200
      repos = JSON.parse(response)
      repos.each do |repo|
        # puts JSON.pretty_generate(repo)
        if !TomProject.exists?(repoid: repo['id'], source: SOURCE)
          puts 'Adding new repo to the list...'
          project = TomProject.new(
            name: repo['name'],
            repo_fullname: repo['path_with_namespace'],
            repoid: repo['id'],
            repo_url: repo['web_url'],
            invitation_id: "#{repo['id']}_-#{SOURCE}",
            inviter_login: repo['owner']['username'],
            permissions: repo['permissions']['project_access']['access_level'],
            is_private: repo['visibility'] == 'public' ? 'False' : 'True',
            owner_login: repo['owner']['username'],
            repo_created_at: DateTime.parse(repo['created_at']),
            is_archived: repo['archived'],
            source: SOURCE,
            isactive: 'Y'
          )

        else
          puts 'updating repo info...'
          project = TomProject.where(repoid: repo['id'], source: SOURCE).first
          project.is_private = repo['visibility'] == 'public' ? 'False' : 'True'
          project.owner_login = repo['owner']['username']
          project.repo_created_at = DateTime.parse(repo['created_at'])
          project.is_archived = repo['archived']
        end
        project.save
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

  def get_repos_full_update
    host = "#{Socket.gethostname}-#{Thread.current.object_id}"
    settings = TomSetting.where('agentname = :agentname', {
                                  agentname: SOURCE, host: host
                                }).order(node_name: :asc).first

    puts Time.now.midnight
    puts Time.now.midnight + 1.day

    project_list = TomProject.where("source = :source and node_name is null and  (last_scanner_date is null or not( last_scanner_date between (now() - INTERVAL '15 DAY') and now())) and (status ='W' or status is null) ", {
                                      source: SOURCE
                                    }).limit(1)

    if project_list.length.positive?
      project_list.update(node_name: host, status: 'L')

      project_list = TomProject.where('source = :source and node_name = :host and status = :status', {
                                        source: SOURCE,
                                        host: host,
                                        status: 'L'
                                      }).each do |project|
        puts "using node -> #{host}"
        t1 = Time.now.to_f
        puts "repo_fullname -> #{project.repo_fullname}"
        # get_commits_info(settings, project)
        # get_forks_info(settings, project)
        # get_issues_info(settings, project)
        # get_pulls_info(settings, project)
        # get_release_info(settings, project)
        # get_workflows_info(settings, project)
        get_repo_owner_info(settings, project)
        # get_daily_report(settings, project)
        t2 = Time.now.to_f
        delta = t2 - t1
        puts "time used -> #{delta}"
        project.last_analysis_time_elapsed = delta.to_s
        # project.last_scanner_date = Time.current.iso8601
        project.status = 'W'
      rescue StandardError => e
        project.last_scanner_date = Time.current.iso8601
        project.last_analysis_time_elapsed = "Error -> #{e}"
        puts "caught exception #{e}!"
        project.status = 'E'
      ensure
        project.node_name = nil
        project.status = 'W'
        project.save
      end
    else
      return false
    end
    true
  end

  def get_commits_info(settings, repo_info)
    last_commit = ''
    info_url_template = settings.commits_info_url.dup

    puts "info_url_template -> #{info_url_template}"
    # Test again
    request_url = info_url_template.sub! '#repo_id', repo_info.repoid
    request_url = request_url.sub! '#start_date',
                                   (repo_info.last_scanner_date.nil? ? repo_info.repo_created_at : repo_info.last_scanner_date).to_s
    page_counter = 0
    loop do
      page_counter += 1
      puts "getting page commits -> #{page_counter}"
      puts "url -> #{request_url}"

      response = HTTP["PRIVATE-TOKEN": getNextToken.to_s].get(
        "#{request_url}?per_page=100&page=#{page_counter}", json: {}
      )

      # puts JSON.pretty_generate(response.parse[0])

      if response.code == 200
        commits = JSON.parse(response)
        break if commits.length.zero?

        if repo_info.last_commit_id.nil?
          puts 'no last commit found!!'
          # last_commit = commits.last["short_id"]
          repo_info.last_commit_id = commits.last['short_id']
          repo_info.save
        else
          puts "last commit -> #{repo_info.last_commit_id}"
        end

        newest_commit = commits.first

        if repo_info.last_commit_id != newest_commit['short_id']
          puts 'There is something new'

          commits.each do |commit|
            next if TomCommitsMetric.exists?(repoid: repo_info.repoid, base_commit_id: commit['short_id'])

            repoUpdate = TomCommitsMetric.new(
              repoid: repo_info.repoid,
              full_name: repo_info.repo_fullname,
              repo_name: repo_info.name,
              base_commit_id: commit['short_id'],
              commit_datetime: DateTime.parse(commit['committed_date']),
              message_length: commit['message'].length,
              total_added: commit['stats']['additions'],
              total_removed: commit['stats']['deletions'],
              total_changed: commit['stats']['total']
            )
            repoUpdate.save
          end

          repo_info.last_commit_id = newest_commit['sha']
          repo_info.save
        else
          puts 'There is no new information!!'
          break
        end
      else
        puts JSON.pretty_generate(response.parse)
        break
      end
    end
    true
  end

  def get_forks_info(settings, repo_info)
    puts "getting forks info for -> #{repo_info.repo_fullname}"

    info_url_template = settings.forks_info_url.dup

    # Getting info about forks

    puts "forks_info_url -> #{info_url_template}"

    request_url = info_url_template.sub! '#repo_id', repo_info.repoid

    page_counter = 0
    loop do
      page_counter += 1
      puts "getting page forks -> #{page_counter}"

      response = HTTP["PRIVATE-TOKEN": getNextToken.to_s].get(
        "#{request_url}?per_page=100&page=#{page_counter}", json: {}
      )
      if response.code == 200
        forks_info = JSON.parse(response)

        break if forks_info.length.zero?

        forks_info.each do |f|
          if !TomForkInfo.exists?(folk_id: f['id'], repoid: repo_info.repoid)
            newRow = TomForkInfo.new(
              folk_id: f['id'],
              repoid: repo_info.repoid,
              repo_fullname: repo_info.repo_fullname,
              folk_fullname: f['path_with_namespace'],
              owner: f['owner']['username'],
              is_private: f['visibility'] == 'public',
              created_at_ext: !f['created_at'].nil? ? DateTime.parse(f['created_at']) : nil
              # updated_at_ext: !f["updated_at"].nil? ? DateTime.parse(f["updated_at"]) : nil, # not supported by gitlab
              # pushed_at_ext: !f["pushed_at"].nil? ? DateTime.parse(f["pushed_at"]) : nil, # not supported by gitlab
            )
            newRow.save
          else
            fork = TomForkInfo.where(folk_id: f['id'], repoid: repo_info.repoid).first

            fork.folk_fullname = f['path_with_namespace']
            fork.owner = f['owner']['username']
            fork.is_private = f['visibility'] == 'public'
            fork.created_at_ext = !f['created_at'].nil? ? DateTime.parse(f['created_at']) : nil
            # fork.updated_at_ext = !f["updated_at"].nil? ? DateTime.parse(f["updated_at"]) : nil # not supported by gitlab
            # fork.pushed_at_ext = !f["pushed_at"].nil? ? DateTime.parse(f["pushed_at"]) : nil # not supported by gitlab
            fork.save
          end
        end
      else
        puts JSON.pretty_generate(response.parse)
        break
      end
    end

    true
  end

  def get_issues_info(settings, repo_info)
    puts "getting issues info for -> #{repo_info.repo_fullname}"

    info_url_template = settings.issues_info_url.dup

    # Getting info about issues

    puts "issues_info_url -> #{info_url_template}"

    request_url = info_url_template.sub! '#repo_id', repo_info.repoid

    page_counter = 0
    loop do
      page_counter += 1
      puts "getting page issues 1-> #{page_counter}"

      response = HTTP["PRIVATE-TOKEN": getNextToken.to_s].get(
        "#{request_url}?per_page=100&page=#{page_counter}", json: {}
      )
      if response.code == 200
        # puts JSON.pretty_generate(response.parse)

        issues_info = JSON.parse(response)

        break if issues_info.length.zero?

        issues_info.each do |issue|
          if !TomIssuesInfo.exists?(issue_id: issue['id'], repoid: repo_info.repoid)
            newRow = TomIssuesInfo.new(
              repoid: repo_info.repoid,
              repo_fullname: repo_info.repo_fullname,
              issue_id: issue['id'],
              issue_number: issue['iid'],
              title: issue['title'],
              created_by_ext: issue['author']['username'],
              labels_count: !issue['labels'].nil? ? issue['labels'].length : 0,
              state: issue['state'],
              asssigned_count: issue['assignees'].length,
              milestone_title: !issue['milestone'].nil? ? issue['milestone']['title'] : nil,
              created_at_ext: !issue['created_at'].nil? ? DateTime.parse(issue['created_at']) : nil,
              updated_at_ext: !issue['updated_at'].nil? ? DateTime.parse(issue['updated_at']) : nil,
              closed_at_ext: !issue['closed_at'].nil? ? DateTime.parse(issue['closed_at']) : nil,
              comments_count: issue['user_notes_count'],
              # author_association: issue["author_association"], # not supported by gitlab
              body_length: !issue['description'].nil? ? issue['description'].length : 0,
              reactions_count: (!issue['upvotes'].nil? ? issue['upvotes'] : 0) + (!issue['downvotes'].nil? ? issue['downvotes'] : 0)
            )

            newRow.labels = issue['labels'].join(',')

            newRow.save
          else
            issue_info = TomIssuesInfo.where(issue_id: issue['id'], repoid: repo_info.repoid).first
            issue_info.title = issue['title']
            issue_info.created_by_ext = issue['author']['username']
            issue_info.labels_count = !issue['labels'].nil? ? issue['labels'].length : 0
            issue_info.state = issue['state']
            issue_info.asssigned_count = issue['assignees'].length
            issue_info.milestone_title = issue['milestone'].present? ? issue['milestone']['title'] : nil
            issue_info.updated_at_ext = !issue['updated_at'].nil? ? DateTime.parse(issue['updated_at']) : nil
            issue_info.closed_at_ext = !issue['user_notes_count'].nil? ? DateTime.parse(issue['closed_at']) : nil
            issue_info.comments_count = issue['comments']
            issue_info.body_length = !issue['description'].nil? ? issue['description'].length : 0
            issue_info.reactions_count = (!issue['upvotes'].nil? ? issue['upvotes'] : 0) + (!issue['downvotes'].nil? ? issue['downvotes'] : 0)

            issue_info.labels = issue['labels'].join(',')
            issue_info.save
          end

          page_comments_counter = 0

          loop do
            page_comments_counter += 1
            puts "getting page issues 2-> #{page_comments_counter}"

            response_comments = HTTP["PRIVATE-TOKEN": getNextToken.to_s].get(
              "#{issue['_links']['notes']}?per_page=100&page=#{page_comments_counter}", json: {}
            )

            if response_comments.code == 200
              comments_issue_info = JSON.parse(response_comments)

              break if comments_issue_info.length.zero?

              comments_issue_info.each do |comment|
                if !TomIssuesComment.exists?(comment_ext_id: comment['id'], repoid: repo_info.repoid)
                  newCommentRow = TomIssuesComment.new(
                    repoid: repo_info.repoid,
                    repo_fullname: repo_info.repo_fullname,
                    comment_ext_id: comment['id'],
                    comment_created_by: comment['author']['username'],
                    comment_created_at: !comment['created_at'].nil? ? DateTime.parse(comment['created_at']) : nil,
                    comment_updated_at: !comment['updated_at'].nil? ? DateTime.parse(comment['updated_at']) : nil,
                    # author_association: comment["author_association"], # not supported by gitlab
                    body: comment['body'],
                    body_len: !comment['body'].nil? ? comment['body'].length : 0
                    # total_reactions_counter: comment["reactions"]["total_count"],
                  )
                  newCommentRow.save
                else
                  comments_info = TomIssuesComment.where(comment_ext_id: comment['id'], repoid: repo_info.repoid).first

                  comments_info.comment_created_by = comment['author']['username']
                  comments_info.comment_created_at = !comment['created_at'].nil? ? DateTime.parse(comment['created_at']) : nil
                  comments_info.comment_updated_at = !comment['updated_at'].nil? ? DateTime.parse(comment['updated_at']) : nil
                  # comments_info.author_association = comment["author_association"] # not supported by gitlab
                  comments_info.body = comment['body']
                  comments_info.body_len = !comment['body'].nil? ? comment['body'].length : 0
                  # comments_info.total_reactions_counter = comment["reactions"]["total_count"] # not supported by gitlab

                  comments_info.save
                end
              end
            else
              break
            end
          end
        end
      else
        puts JSON.pretty_generate(response.parse)
        break
      end
    end
    true
  end

  def get_pulls_info(settings, repo_info)
    puts "getting pulls info for -> #{repo_info.repo_fullname}"

    info_url_template = settings.pulls_info_url.dup

    # Getting info about issues

    puts "pulls_info_url -> #{info_url_template}"

    request_url = info_url_template.sub! '#repo_id', repo_info.repoid

    page_counter = 0
    loop do
      page_counter += 1
      puts "getting page pulls-> #{page_counter}"

      response = HTTP["PRIVATE-TOKEN": getNextToken.to_s].get(
        "#{request_url}?per_page=100&page=#{page_counter}", json: {}
      )
      if response.code == 200
        pulls_info = JSON.parse(response)

        break if pulls_info.length.zero?

        pulls_info.each do |pull|
          if !TomPullInfo.exists?(pull_id: pull['id'])
            newRow = TomPullInfo.new(
              repoid: repo_info.repoid,
              repo_fullname: repo_info.repo_fullname,
              pull_id: pull['id'],
              pull_number: pull['iid'],
              state: pull['state'],
              title: pull['title'],
              title_length: !pull['title'].nil? ? pull['title'].length : 0,
              owner: pull['author']['username'],
              body_length: !pull['description'].nil? ? pull['description'].length : 0,
              created_at_ext: !pull['created_at'].nil? ? DateTime.parse(pull['created_at']) : nil,
              updated_at_ext: !pull['updated_at'].nil? ? DateTime.parse(pull['updated_at']) : nil,
              closed_at_ext: !pull['closed_at'].nil? ? DateTime.parse(pull['closed_at']) : nil,
              merged_at_ext: !pull['merged_at'].nil? ? DateTime.parse(pull['merged_at']) : nil,
              asssigned_count: pull['assignees'].length,
              req_review_count: pull['reviewers'].length,
              labels_count: pull['labels'].length,
              milestone_title: !pull['milestone'].nil? ? pull['milestone']['title'] : nil,
              # author_association: pull["author_association"], # not supported by gitlab
              head_commit_id: pull['sha'],
              # base_commit_id: pull["base"]["sha"], # not supported by gitlab
              # commits_counts: pull["commits"], # not supported by gitlab
              is_locked: pull['blocking_discussions_resolved']
            )

            newRow.labels = pull['labels'].join(',')
            newRow.code_blocks_counter = 0
            newRow.links_counter = 0

            puts "getting MR comments info for 1 -> #{repo_info.repo_fullname}"
            response = HTTP["PRIVATE-TOKEN": getNextToken.to_s].get(
              "#{request_url}/#{pull['iid']}/notes", json: {}
            )

            if response.code == 200
              comments_pulls = JSON.parse(response)

              comments_pulls.each do |c|
                if !TomPrComment.exists?(comment_ext_id: c['id'], repoid: repo_info.repoid)
                  newCommentRow = TomPrComment.new(
                    repoid: repo_info.repoid,
                    repo_fullname: repo_info.repo_fullname,
                    comment_ext_id: c['id'],
                    comment_created_by: c['author']['username'],
                    comment_created_at: !c['created_at'].nil? ? DateTime.parse(c['created_at']) : nil,
                    comment_updated_at: !c['updated_at'].nil? ? DateTime.parse(c['updated_at']) : nil,
                    # author_association: c["author_association"], # not supported by gitlab
                    body: c['body'],
                    body_len: !c['body'].nil? ? c['body'].length : 0
                    # total_reactions_counter: c["reactions"]["total_count"], # not supported by gitlab
                  )
                  newCommentRow.save
                else
                  comments_info = TomPrComment.where(comment_ext_id: c['id'], repoid: repo_info.repoid).first

                  comments_info.comment_created_by = c['author']['username']
                  comments_info.comment_created_at = !c['created_at'].nil? ? DateTime.parse(c['created_at']) : nil
                  comments_info.comment_updated_at = !c['updated_at'].nil? ? DateTime.parse(c['updated_at']) : nil
                  # comments_info.author_association = c["author_association"] # not supported by gitlab
                  comments_info.body = c['body']
                  comments_info.body_len = !c['body'].nil? ? c['body'].length : 0
                  # comments_info.total_reactions_counter = c["reactions"]["total_count"] # not supported by gitlab

                  comments_info.save
                end
                newRow.code_blocks_counter = newRow.code_blocks_counter + (c['body'].count('```') / 2)
                newRow.links_counter = newRow.code_blocks_counter + c['body'].count('http')
              end
            end

            newRow.save
          else
            pull_info = TomPullInfo.where(pull_id: pull['id']).first

            pull_info.state = pull['state']
            pull_info.title = pull['title']
            pull_info.title_length = !pull['title'].nil? ? pull['title'].length : 0
            pull_info.body_length = !pull['body'].nil? ? pull['body'].length : 0
            pull_info.updated_at_ext = !pull['updated_at'].nil? ? DateTime.parse(pull['updated_at']) : nil
            pull_info.closed_at_ext = !pull['closed_at'].nil? ? DateTime.parse(pull['closed_at']) : nil
            pull_info.merged_at_ext = !pull['merged_at'].nil? ? DateTime.parse(pull['merged_at']) : nil
            pull_info.asssigned_count = pull['assignees'].length
            pull_info.req_review_count = pull['reviewers'].length
            pull_info.labels_count = pull['labels'].length
            pull_info.milestone_title = !pull['milestone'].nil? ? pull['milestone']['title'] : nil
            # pull_info.author_association = pull["author_association"] # not supported by gitlab
            # pull_info.commits_counts = pull["commits"] # not supported by gitlab
            pull_info.is_locked = pull['blocking_discussions_resolved']

            pull_info.labels = pull['labels'].join(',')
            pull_info.code_blocks_counter = 0
            pull_info.links_counter = 0

            puts "getting RM comments info 2 for -> #{repo_info.repo_fullname}"
            response = HTTP["PRIVATE-TOKEN": getNextToken.to_s].get(
              "#{request_url}/#{pull['iid']}/notes", json: {}
            )

            if response.code == 200
              comments_pulls = JSON.parse(response)

              comments_pulls.each do |c|
                if !TomPrComment.exists?(comment_ext_id: c['id'], repoid: repo_info.repoid)
                  newCommentRow = TomPrComment.new(
                    repoid: repo_info.repoid,
                    repo_fullname: repo_info.repo_fullname,
                    comment_ext_id: c['id'],
                    comment_created_by: c['author']['username'],
                    comment_created_at: !c['created_at'].nil? ? DateTime.parse(c['created_at']) : nil,
                    comment_updated_at: !c['updated_at'].nil? ? DateTime.parse(c['updated_at']) : nil,
                    # author_association: c["author_association"], # not supported by gitlab
                    body: c['body'],
                    body_len: !c['body'].nil? ? c['body'].length : 0
                    # total_reactions_counter: c["reactions"]["total_count"], # not supported by gitlab
                  )
                  newCommentRow.save
                else
                  comments_info = TomPrComment.where(comment_ext_id: c['id'], repoid: repo_info.repoid).first

                  comments_info.comment_created_by = c['author']['username']
                  comments_info.comment_created_at = !c['created_at'].nil? ? DateTime.parse(c['created_at']) : nil
                  comments_info.comment_updated_at = !c['updated_at'].nil? ? DateTime.parse(c['updated_at']) : nil
                  # comments_info.author_association = c["author_association"] # not supported by gitlab
                  comments_info.body = c['body']
                  comments_info.body_len = !c['body'].nil? ? c['body'].length : 0
                  # comments_info.total_reactions_counter = c["reactions"]["total_count"] # not supported by gitlab

                  comments_info.save
                end

                pull_info.code_blocks_counter = pull_info.code_blocks_counter + (c['body'].count('```') / 2)
                pull_info.links_counter = pull_info.code_blocks_counter + c['body'].count('http')
              end
            end

            pull_info.save
          end
        end
      else
        puts JSON.pretty_generate(response.parse)
        break
      end
    end

    true
  end

  def get_release_info(settings, repo_info)
    puts "getting releases info for -> #{repo_info.repo_fullname}"

    info_url_template = settings.releases_info_url.dup

    # Getting info about releases

    puts "releases_info_url -> #{info_url_template}"

    request_url = info_url_template.sub! '#repo_id', repo_info.repoid

    page_counter = 0
    loop do
      page_counter += 1
      puts "getting page release -> #{page_counter}"

      response = HTTP["PRIVATE-TOKEN": getNextToken.to_s].get(
        "#{request_url}?per_page=100&page=#{page_counter}", json: {}
      )
      if response.code == 200
        releases_info = JSON.parse(response)

        break if releases_info.length.zero?

        releases_info.each do |release|
          # puts JSON.pretty_generate(release)
          if !TomReleaseInfo.exists?(release_id: "#{repo_info.repoid}_#{release['tag_name']}")
            newRow = TomReleaseInfo.new(
              repoid: repo_info.repoid,
              repo_fullname: repo_info.repo_fullname,
              release_id: "#{repo_info.repoid}_#{release['tag_name']}",
              author: release['author']['username'],
              name: release['name'],
              created_at_ext: !release['created_at'].nil? ? DateTime.parse(release['created_at']) : nil,
              published_at_ext: !release['released_at'].nil? ? DateTime.parse(release['released_at']) : nil,
              assets_count: release['assets']['count'],
              body_length: !release['description'].nil? ? release['description'].length : 0
              # reactions_count: !release["reactions"].nil? ? release["reactions"]["total_count"] : 0, # not supported by gitlab
            )
            newRow.save
          else
            rel = TomReleaseInfo.where(release_id: "#{repo_info.repoid}_#{release['tag_name']}").first
            rel.name = release['name']
            rel.created_at_ext = !release['created_at'].nil? ? DateTime.parse(release['created_at']) : nil
            rel.published_at_ext = !release['released_at'].nil? ? DateTime.parse(release['released_at']) : nil
            rel.assets_count = release['assets']['count']
            rel.body_length = !release['description'].nil? ? release['description'].length : 0
            # rel.reactions_count = !release["reactions"].nil? ? release["reactions"]["total_count"] : 0 # not supported by gitlab
            rel.save
          end
        end
      else
        puts JSON.pretty_generate(response.parse)
        break
      end
    end

    true
  end

  def get_workflows_info(settings, repo_info)
    puts "getting workflows info for -> #{repo_info.repo_fullname}"

    info_url_template = settings.workflows_info_url.dup

    # Getting info about workflows

    puts "workflows_info_url -> #{info_url_template}"

    request_url = info_url_template.sub! '#repo_id', repo_info.repoid

    page_counter = 0
    loop do
      page_counter += 1
      puts "getting page wf -> #{page_counter}"

      response = HTTP["PRIVATE-TOKEN": getNextToken.to_s].get(
        "#{request_url}?per_page=100&page=#{page_counter}", json: {}
      )
      if response.code == 200
        workflows_info = JSON.parse(response)
        break if workflows_info.length.zero?

        workflows_info.each do |w|
          response = HTTP["PRIVATE-TOKEN": getNextToken.to_s].get(
            "#{request_url}/#{w['id']}", json: {}
          )

          next unless response.code == 200

          workflows_info_det = JSON.parse(response)

          if !TomWorkflowInfo.exists?(action_id: "#{workflows_info_det['id']}_#{repo_info.repoid}")
            newRow = TomWorkflowInfo.new(
              repoid: repo_info.repoid,
              repo_fullname: repo_info.repo_fullname,
              action_id: workflows_info_det['id'].to_s + +'_' + repo_info.repoid,
              name: "gilab_release_#{workflows_info_det['iid']}",
              action_number: workflows_info_det['iid'],
              event: workflows_info_det['source'],
              status: workflows_info_det['status'],
              # conclusion: workflows_info_det["conclusion"], # not supported by gitlab
              workflow_id: workflows_info_det['project_id'],
              # run_attempt_count: workflows_info_det["run_attempt"], # not supported by gitlab
              created_at_ext: !workflows_info_det['created_at'].nil? ? DateTime.parse(workflows_info_det['created_at']) : nil,
              updated_at_ext: !workflows_info_det['updated_at'].nil? ? DateTime.parse(workflows_info_det['updated_at']) : nil,
              started_at_ext: !workflows_info_det['started_at'].nil? ? DateTime.parse(workflows_info_det['started_at']) : nil,
              actor: workflows_info_det['user']['username']
            )
            newRow.save
          else
            wf = TomWorkflowInfo.where(action_id: "#{workflows_info_det['id']}_#{repo_info.repoid}").first
            wf.name = "gilab_release_#{workflows_info_det['iid']}"
            wf.action_number = workflows_info_det['iid']
            wf.event = workflows_info_det['source']
            wf.status = workflows_info_det['status']
            # wf.conclusion = workflows_info_det["conclusion"] # not supported by gitlab
            wf.workflow_id = workflows_info_det['project_id']
            # wf.run_attempt_count = workflows_info_det["run_attempt"] # not supported by gitlab
            wf.created_at_ext = !workflows_info_det['created_at'].nil? ? DateTime.parse(workflows_info_det['created_at']) : nil
            wf.updated_at_ext = !workflows_info_det['updated_at'].nil? ? DateTime.parse(workflows_info_det['updated_at']) : nil
            wf.started_at_ext = !workflows_info_det['started_at'].nil? ? DateTime.parse(workflows_info_det['started_at']) : nil
            wf.actor = workflows_info_det['user']['username']
            wf.save
          end
        end
      else
        puts JSON.pretty_generate(response.parse)
        break
      end
    end

    true
  end

  def getQueueCounter
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  def get_tokens
    if @@tokens.nil?
      puts 'Getting token list!!'
      @@tokens = TomTokensQueue.where(source: SOURCE).where(isactive: 'Y')
    end
  end

  def start_radar
    puts 'initializing radar...'
    @@External_threar_stop = false
    if @@Is_active_instance == false
      puts 'there is no active instance, setting up a new one...'
      @@Is_active_instance = true
      loop do
        check_new_invitations
        puts 'Processing new invitations...'
        _limit = getQueueCounter
        if _limit.positive?
          [*1.._limit].each do |p|
            get_repos_full_update
            puts "Processing repo -> #{p}..."
            sleep(2)
            next unless @@External_threar_stop == true

            puts 'signal stop catched...'
            @@Is_active_instance = false
            return true
          end
        else
          sleep(60)
        end

        next unless @@External_threar_stop == true

        puts 'signal stop catched...'
        @@Is_active_instance = false
        return true
      end
    else
      puts 'there is already an instance runing...'
      false
    end
  end

  def stop_radar
    @@External_threar_stop = true
    puts 'signal stop sent...'
  end

  def getNextToken
    @@call_count += 1
    next_token_index = (@@call_count % @@tokens.length)
    @@tokens[next_token_index].token
  end
end
