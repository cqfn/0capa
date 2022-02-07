# frozen_string_literal: false

require "json"
require "git"
require "fileutils"
# require "Time"
require "socket"

require_relative "radar_base_controller"

class GithubRadar < RadarBaseController
  SOURCE = "github"
  @@Tokens = nil
  @@call_count = 0

  def initialize
    puts "initialize GithubRadar"
    Initialize(SOURCE)
    get_tokens()
  end

  def get_tokens()
    if @@Tokens.nil?
      puts "Getting token list!!"
      @@Tokens = TomTokensQueue.where(source: SOURCE).where(isactive: "Y")
    end
  end

  def check_new_invitations()
    host = Socket.gethostname
    settings = TomSetting.where("agentname = :agentname and (node_name = :host or node_name is null) ", {
      agentname: SOURCE,
      host: host,
    }).order(node_name: :asc).first

    response = HTTP[accept: settings.content_type, Authorization: "token #{getNextToken()}"].get(
      settings.invitations_endpoint, json: {},
    )
    puts JSON.pretty_generate(response.parse)

    if response.code == 200
      invitations = JSON.parse(response)

      invitations.each {
        |invitation|
        puts JSON.pretty_generate(invitation)

        if invitation["expired"] != true
          project = TomProject.new(
            name: invitation["repository"]["name"],
            repo_fullname: invitation["repository"]["full_name"],
            repoid: invitation["repository"]["id"],
            repo_url: invitation["repository"]["url"],
            invitation_id: invitation["id"],
            inviter_login: invitation["inviter"]["login"],
            permissions: invitation["permissions"],
            is_private: invitation["repository"]["private"] == true ? "True" : "False",
            owner_login: invitation["repository"]["owner"]["login"],
            source: SOURCE,
            isactive: "Y",
          )
          accept_url = settings.invitations_accept_endpoint.sub! "#invitation_id", invitation["id"].to_s

          invitation_response = HTTP[accept: settings.content_type, Authorization: "token #{getNextToken()}"].patch(
            accept_url, json: {},
          )
          puts "invitation_response -> " + invitation_response.code.to_s
          if invitation_response.code == 204
            info_url_template = settings.repos_info_url.dup

            puts "info_url_template -> " + info_url_template

            request_url = info_url_template.sub! "#repo_fullname", repo_info.repo_fullname

            response = HTTP[accept: settings.content_type, Authorization: "token #{getNextToken()}"].get(
              request_url, json: {},
            )
            if invitation_response.code == 200
              repo = JSON.parse(response)
              project.repo_created_at = DateTime.parse(repo["created_at"])
            else
              puts JSON.pretty_generate(response.parse)
            end

            project.save
          else
            raise "It was a error accepting collaboration invitation."
          end
        end
      }
    else
      puts JSON.pretty_generate(response.parse)
      return false
    end
    return true
  end

  def check_repos_update()
    host = Socket.gethostname
    settings = TomSetting.where("agentname = :agentname", {
      agentname: SOURCE, host: host,
    }).order(node_name: :asc).first

    # https://api.github.com/repos/#repo_fullname
    puts Time.now.midnight
    puts Time.now.midnight + 1.day
    while true
      project_list = TomProject.where("source = :source and node_name is null and  (last_scanner_date is null or not( last_scanner_date between (now() - INTERVAL '7 DAY') and now())) and (status ='W' or status is null) ", {
        source: SOURCE,
      }).limit(5)

      if project_list.length > 0
        project_list.update(node_name: host, status: "L")
        # project_list.save
        # project_list.each do |project|
        #   project.node_name = host
        #   project.status = "P"
        #   project.save
        # end

        project_list = TomProject.where("source = :source and node_name = :host and status = :status", {
          source: SOURCE,
          host: host,
          status: "L",
        }).each do |project|
          begin
            puts "using node -> " + host
            t1 = Time.now.to_f
            puts "repo_fullname -> " + project.repo_fullname
            get_commits_info(settings, project)
            get_daily_report(settings, project)
            t2 = Time.now.to_f
            delta = t2 - t1
            puts "time used -> " + delta.to_s
            project.last_analysis_time_elapsed = delta.to_s
            project.last_scanner_date = Time.current.iso8601
            project.status = "W"
          rescue => e
            project.last_analysis_time_elapsed = "Error"
            puts "caught exception #{e}!"
            project.status = "E"
          ensure
            project.node_name = nil
            project.save
          end
        end
      else
        break
      end
    end
  end

  def get_commits_info(settings, repo_info)
    if repo_info.repoid.blank?
      puts "getting repository info for -> " + repo_info.repo_fullname

      info_url_template = settings.repos_info_url.dup

      puts "info_url_template -> " + info_url_template

      request_url = info_url_template.sub! "#repo_fullname", repo_info.repo_fullname

      response = HTTP[accept: settings.content_type, Authorization: "token #{getNextToken()}"].get(
        request_url, json: {},
      )
      if response.code == 200
        repo = JSON.parse(response)
        repo_info.repoid = repo["id"]
      else
        puts JSON.pretty_generate(response.parse)
      end
    end

    last_commit = ""
    info_url_template = settings.commits_info_url.dup

    puts "info_url_template -> " + info_url_template

    request_url = info_url_template.sub! "#repo_fullname", repo_info.repo_fullname
    page_counter = 0
    while true
      page_counter += 1
      if repo_info.last_commit_id.nil?
        response = HTTP[accept: settings.content_type, Authorization: "token #{getNextToken()}"].get(
          request_url + "?per_page=100&page=" + page_counter.to_s, json: {},
        )
      else
        response = HTTP[accept: settings.content_type, Authorization: "token #{getNextToken()}", sha: repo_info.last_commit_id].get(
          request_url + "?per_page=100&page=" + page_counter.to_s, json: {},
        )
      end

      # puts JSON.pretty_generate(response.parse[0])

      if response.code == 200
        commits = JSON.parse(response)
        if commits.length == 0
          break
        end

        if repo_info.last_commit_id.nil?
          puts "no last commit found!!"
          last_commit = commits.last["sha"]
          repo_info.last_commit_id = last_commit
          repo_info.save
        else
          puts "last commit -> " + repo_info.last_commit_id
          last_commit = repo_info.last_commit_id
        end

        newest_commit = commits.first

        if repo_info.last_commit_id != newest_commit["sha"]
          puts "There is something new"

          commits.each do |commit|
            response = HTTP[accept: settings.content_type, Authorization: "token #{getNextToken()}"].get(
              commit["url"], json: {},
            )
            if response.code == 200
              commit_info = JSON.parse(response)

              repoUpdate = TomCommitsMetric.new(
                repoid: repo_info.repoid,
                full_name: repo_info.repo_fullname,
                repo_name: repo_info.name,
                base_commit_id: commit_info["sha"][0..6],
                commit_datetime: DateTime.parse(commit_info["commit"]["author"]["date"]),
                message_length: commit_info["commit"]["message"].length,
                total_added: commit_info["stats"]["additions"],
                total_removed: commit_info["stats"]["deletions"],
                total_changed: commit_info["stats"]["total"],
                total_files: commit_info["files"].length,
              )
              repoUpdate.save
            else
              puts JSON.pretty_generate(response.parse)
              break
            end
          end

          repo_info.last_commit_id = newest_commit["sha"]
          repo_info.save
        else
          puts "There is no new information!!"
          return true
        end
      else
        puts JSON.pretty_generate(response.parse)
        break
      end
    end
  end

  def get_daily_report(settings, repo_info)
    projectMetrics = TomProjectMetric.new()
    projectMetrics.repo_fullname = repo_info.repo_fullname

    if repo_info.repo_created_at != nil
      time_diff = Time.current - repo_info.repo_created_at
      repo_age_days = (time_diff / 1.day).round
    end

    puts "getting repository info for -> " + repo_info.repo_fullname

    info_url_template = settings.repos_info_url.dup

    puts "info_url_template -> " + info_url_template

    request_url = info_url_template.sub! "#repo_fullname", repo_info.repo_fullname

    response = HTTP[accept: settings.content_type, Authorization: "token #{getNextToken()}"].get(
      request_url, json: {},
    )
    if response.code == 200
      repo = JSON.parse(response)

      repo_age_days = ((Time.current - DateTime.parse(repo["created_at"])) / 1.day).round
      repo_info.repo_created_at = DateTime.parse(repo["created_at"])
      projectMetrics.repo_size = repo["size"]
      projectMetrics.repo_topics = repo["topics"].length
      projectMetrics.repo_age_days = repo_age_days
      projectMetrics.repo_watchers = repo["watchers"]
      projectMetrics.repo_network_members = repo["network_count"]

      page_counter = 0
      request_url = repo["branches_url"].sub! "{/branch}", ""

      projectMetrics.repo_branches = 0
      puts "getting branch info"
      while true
        page_counter += 1

        response = HTTP[accept: settings.content_type, Authorization: "token #{getNextToken()}"].get(
          request_url + "?per_page=100&page=" + page_counter.to_s, json: {},
        )
        if response.code == 200
          branches = JSON.parse(response)
          if branches.length == 0
            break
          end
          projectMetrics.repo_branches += branches.length
        else
          puts JSON.pretty_generate(response.parse)
          break
        end
      end

      puts "getting workflows info"
      page_counter = 0
      info_url_template = "https://api.github.com/repos/#repo_fullname/actions/workflows"
      request_url = info_url_template.sub! "#repo_fullname", repo_info.repo_fullname

      response = HTTP[accept: settings.content_type, Authorization: "token #{getNextToken()}"].get(
        request_url, json: {},
      )
      if response.code == 200
        workflows = JSON.parse(response)
        projectMetrics.repo_workflows = workflows["total_count"]
      else
        puts JSON.pretty_generate(response.parse)
        projectMetrics.repo_workflows = 0
      end

      puts "getting languages info"
      request_url = repo["languages_url"]

      response = HTTP[accept: settings.content_type, Authorization: "token #{getNextToken()}"].get(
        request_url, json: {},
      )
      if response.code == 200
        languages = JSON.parse(response)
        projectMetrics.repo_languages = languages.length
      else
        puts JSON.pretty_generate(response.parse)
        projectMetrics.repo_languages = 0
      end

      page_counter = 0
      request_url = repo["milestones_url"].sub! "{/number}", ""

      projectMetrics.repo_milestones = 0
      while true
        page_counter += 1

        response = HTTP[accept: settings.content_type, Authorization: "token #{getNextToken()}"].get(
          request_url + "?per_page=100&page=" + page_counter.to_s, json: {},
        )
        if response.code == 200
          milestones = JSON.parse(response)
          if milestones.length == 0
            break
          end
          projectMetrics.repo_milestones += milestones.length
        else
          puts JSON.pretty_generate(response.parse)
          projectMetrics.repo_milestones = 0
          break
        end
      end

      page_counter = 0
      request_url = repo["deployments_url"]

      projectMetrics.repo_deployments = 0
      while true
        page_counter += 1

        response = HTTP[accept: settings.content_type, Authorization: "token #{getNextToken()}"].get(
          request_url + "?per_page=100&page=" + page_counter.to_s, json: {},
        )
        if response.code == 200
          deployments = JSON.parse(response)
          if deployments.length == 0
            break
          end
          projectMetrics.repo_deployments += deployments.length
        else
          puts JSON.pretty_generate(response.parse)
          break
        end
      end

      info_url_template = "https://api.github.com/repos/#repo_fullname/readme"
      request_url = info_url_template.sub! "#repo_fullname", repo_info.repo_fullname

      response = HTTP[accept: settings.content_type, Authorization: "token #{getNextToken()}"].get(
        request_url, json: {},
      )
      if response.code == 200
        readme = JSON.parse(response)
        projectMetrics.repo_readme_length = readme["size"]
      else
        puts JSON.pretty_generate(response.parse)
        projectMetrics.repo_readme_length = 0
      end
    else
      puts "Error retriving data -> " + response.message
      puts JSON.pretty_generate(response.parse)
      raise StandardError.new "Error retriving data, " + response.message
    end

    puts "getting commits info for -> " + repo_info.repo_fullname

    sql = "select sum(total_added) total_added, sum(total_removed) total_removed, sum(total_changed) total_changed, 
                    ROUND(avg(total_added), 0) avg_added, ROUND(avg(total_removed), 0) avg_removed, ROUND(avg(total_changed), 0) avg_changed,
                    ROUND(avg(total_files), 0) avg_files_changed, ROUND(avg(message_length), 0) avg_message_length, count(1) commits_count,
                    max(commit_datetime) last_commit, min(commit_datetime) first_commit
               from tom_commits_metrics c
               where full_name = ?
              group by repoid"

    TomCommitsMetric.find_by_sql([sql, repo_info.repo_fullname]).each do |row|
      projectMetrics.commits_total_lines_added = row.total_added
      projectMetrics.commits_total_lines_removed = row.total_removed
      projectMetrics.commits_avg_files_changed = row.avg_files_changed
      projectMetrics.commits_avg_added = row.avg_added
      projectMetrics.commits_avg_removed = row.avg_removed
      projectMetrics.commits_avg_message_length = row.avg_message_length
      projectMetrics.commits_count = row.commits_count

      time_diff = Time.current - row.first_commit
      puts "time since first commit -> " + (time_diff / 1.day).round.to_s
      projectMetrics.commits_days_since_first = (time_diff / 1.day).round

      time_diff = Time.current - row.last_commit
      puts "time since last commit -> " + (time_diff / 1.day).round.to_s
      projectMetrics.commits_days_since_last = (time_diff / 1.day).round
    end

    sql = "select max(count_per_day) max_count_per_day, ROUND(avg(count_per_day), 0) avg_count_per_day
             from(
                  select date_trunc('day', commit_datetime) commit_datetime, count(1) count_per_day
                    from tom_commits_metrics c
                   where full_name = ?
                   group by repoid, date_trunc('day', commit_datetime)) x"

    TomCommitsMetric.find_by_sql([sql, repo_info.repo_fullname]).each do |row|
      projectMetrics.commits_avg_per_day_real = row.avg_count_per_day
      projectMetrics.commits_max_per_day = row.max_count_per_day
    end

    puts "getting contributors info for -> " + repo_info.repo_fullname

    info_url_template = settings.contributors_info_url.dup

    # Getting info about contributors
    # info_url_template = "https://api.github.com/repos/#repo_fullname/stats/contributors"

    # puts "contributors_info_url -> " + settings.contributors_info_url
    puts "contributors_info_url -> " + info_url_template

    request_url = info_url_template.sub! "#repo_fullname", repo_info.repo_fullname

    contributors_list = []

    response = HTTP[accept: settings.content_type, Authorization: "token #{getNextToken()}"].get(
      request_url, json: {},
    )

    if response.code == 200
      contributors_info = JSON.parse(response)

      contributors_sorted = contributors_info.sort_by { |c| c["total"] }

      projectMetrics.contributors_count = contributors_sorted.length

      # puts "contributors_count -> " + contributors_sorted.length.to_s

      total_overall = contributors_sorted[0, 100].map { |c| c["total"] }.inject(0, &:+)
      max_top_100_count = contributors_sorted[0, 100].length
      # puts "top-100  -> " + max_top_100_count.to_s
      # puts "total_overall -> " + total_overall.to_s
      if max_top_100_count > 0
        projectMetrics.contributors_top_avg_commits = total_overall / max_top_100_count
      else
        projectMetrics.contributors_top_avg_commits = 0
      end

      total_top_100_added = 0
      total_top_100_removed = 0
      total_top_100_weeks_active = 0
      contributors_sorted[0, 100].each do |c|
        weeks = c["weeks"]
        total_top_100_added += weeks.map { |w| w["a"] }.inject(0, :+)
        total_top_100_removed += weeks.map { |w| w["d"] }.inject(0, &:+)
        total_top_100_weeks_active += weeks.select { |w| w["c"].to_i > 0 }.length
      end
      if total_overall > 0
        projectMetrics.contributors_top_avg_additions = total_top_100_added / total_overall
        projectMetrics.contributors_top_avg_deletions = total_top_100_removed / total_overall
      else
        projectMetrics.contributors_top_avg_additions = 0
        projectMetrics.contributors_top_avg_deletions = 0
      end
      if max_top_100_count > 0
        projectMetrics.contributors_top_avg_participation_week = total_top_100_weeks_active / max_top_100_count
      else
        projectMetrics.contributors_top_avg_participation_week = 0
      end
    else
      puts JSON.pretty_generate(response.parse)
      projectMetrics.contributors_count = 0
      projectMetrics.contributors_top_avg_commits = 0
      projectMetrics.contributors_top_avg_additions = 0
      projectMetrics.contributors_top_avg_deletions = 0
      projectMetrics.contributors_top_avg_participation_week = 0
    end

    contributors_list = nil

    puts "getting forks info for -> " + repo_info.repo_fullname

    info_url_template = settings.forks_info_url.dup

    # Getting info about forks

    puts "forks_info_url -> " + info_url_template

    request_url = info_url_template.sub! "#repo_fullname", repo_info.repo_fullname

    page_counter = 0
    forks_list = []
    while true
      page_counter += 1
      puts "getting page forks -> " + page_counter.to_s

      response = HTTP[accept: settings.content_type, Authorization: "token #{getNextToken()}"].get(
        request_url + "?per_page=100&page=" + page_counter.to_s, json: {},
      )
      if response.code == 200
        forks_info = JSON.parse(response)

        if forks_info.length == 0
          break
        end

        forks_info.each do |f|
          forks_list.push(f.dup)
        end
      else
        puts JSON.pretty_generate(response.parse)
        break
      end
    end

    if forks_list.length > 0
      projectMetrics.forks_count = forks_list.length

      # puts "forks_list -> " + forks_list.length.to_s

      forks_grouped = forks_list.group_by { |f| DateTime.parse(f["created_at"]).beginning_of_day }.sort_by { |x| x[1].length }

      if forks_grouped.length > 0
        # puts "forks_grouped l -> " + forks_grouped.last[1].length.to_s

        projectMetrics.forks_avg_max_per_day = forks_grouped.last[1].length.to_s
        projectMetrics.forks_avg_per_day = forks_list.length / repo_age_days
      else
        projectMetrics.forks_avg_max_per_day = 0
        projectMetrics.forks_avg_per_day = 0
      end
    else
      projectMetrics.forks_count = 0
      projectMetrics.forks_avg_max_per_day = 0
      projectMetrics.forks_avg_per_day = 0
    end

    forks_list = nil

    puts "getting issues info for -> " + repo_info.repo_fullname

    info_url_template = settings.issues_info_url.dup

    # Getting info about issues

    puts "issues_info_url -> " + info_url_template

    request_url = info_url_template.sub! "#repo_fullname", repo_info.repo_fullname

    total_open = 0
    total_closed = 0
    labels = []
    days_closing_time = 0
    sum_title_length = 0
    sum_body_length = 0
    total_comments = 0
    issues_list = []

    page_counter = 0
    while true
      page_counter += 1
      puts "getting page issues-> " + page_counter.to_s

      response = HTTP[accept: settings.content_type, Authorization: "token #{getNextToken()}"].get(
        request_url + "?state=all&page=" + page_counter.to_s, json: {},
      )
      if response.code == 200
        issues_info = JSON.parse(response)

        # puts "page count -> " + issues_info.length.to_s
        if issues_info.length == 0
          break
        end

        issues_info.each do |issue|
          if issue["state"] == "open"
            total_open += 1
          end
          issue["labels"].each do |l|
            labels.push(l["id"])
          end

          if issue["state"] == "closed"
            total_closed += 1
            time_diff = DateTime.parse(issue["created_at"]) - DateTime.parse(issue["created_at"])
            days_closing_time += (time_diff / 1.day).round
          end

          sum_title_length += issue["title"] ? issue["title"].length : 0
          sum_body_length += issue["body"] ? issue["body"].length : 0
          total_comments += issue["comments"]

          issues_list.push(issue.dup)
        end
      else
        puts JSON.pretty_generate(response.parse)
        break
      end
    end

    if issues_list.length > 0
      projectMetrics.issues_count = issues_list.length
      projectMetrics.issues_open = total_open
      projectMetrics.issues_avg_labels = (labels.length / issues_list.length)
      labels.uniq #removing duplicated labels
      projectMetrics.issues_labels = labels.length
      projectMetrics.issues_avg_closing_time = total_closed > 0 ? (days_closing_time / total_closed) : 0
      projectMetrics.issues_avg_title_length = (sum_title_length / issues_list.length)
      projectMetrics.issues_avg_body_length = (sum_body_length / issues_list.length)
      projectMetrics.issues_avg_comments = (total_comments / issues_list.length)

      issues_grouped = issues_list.group_by { |i| DateTime.parse(i["created_at"]).beginning_of_day }.sort_by { |x| x[1].length }

      projectMetrics.issues_max_per_day = issues_grouped.last[1].length.to_s
      projectMetrics.issues_avg_per_day = issues_list.length / repo_age_days
      projectMetrics.issues_avg_per_day_real = issues_list.length / issues_grouped.length
    else
      projectMetrics.issues_count = 0
      projectMetrics.issues_open = 0
      projectMetrics.issues_avg_labels = 0
      projectMetrics.issues_labels = 0
      projectMetrics.issues_avg_closing_time = 0
      projectMetrics.issues_avg_title_length = 0
      projectMetrics.issues_avg_body_length = 0
      projectMetrics.issues_avg_comments = 0
      projectMetrics.issues_max_per_day = 0
      projectMetrics.issues_avg_per_day = 0
      projectMetrics.issues_avg_per_day_real = 0
    end

    labels = nil
    issues_list = nil

    info_url_template = settings.issues_Comments_info_url.dup

    # Getting info about issues

    puts "issues_Comments_info_url -> " + info_url_template

    request_url = info_url_template.sub! "#repo_fullname", repo_info.repo_fullname

    page_counter = 0
    comments_counter = 0
    comments_length = 0
    last_comment_date = nil
    comments_interval_counter_days = 0

    while true
      page_counter += 1
      puts "getting page comments-> " + page_counter.to_s

      response = HTTP[accept: settings.content_type, Authorization: "token #{getNextToken()}"].get(
        request_url + "?per_page=100&page=" + page_counter.to_s, json: {},
      )
      if response.code == 200
        issues_comments_info = JSON.parse(response)

        if issues_comments_info.length == 0
          break
        end
        comments_counter += issues_comments_info.length
        issues_comments_info.each do |c|
          comments_length += c["body"].length

          if last_comment_date != nil
            comments_interval_counter_days += ((DateTime.parse(c["created_at"]) - last_comment_date) / 1.day).round
          end

          last_comment_date = DateTime.parse(c["created_at"])
        end
      else
        puts JSON.pretty_generate(response.parse)
        break
      end
    end
    if comments_counter > 0
      projectMetrics.issues_total_comments = comments_counter
      projectMetrics.issues_avg_comment_time = (comments_interval_counter_days / comments_counter)
      projectMetrics.issues_avg_comment_length = (comments_length / comments_counter)
    else
      projectMetrics.issues_total_comments = 0
      projectMetrics.issues_avg_comment_time = 0
      projectMetrics.issues_avg_comment_length = 0
    end

    puts "getting pulls info for -> " + repo_info.repo_fullname

    info_url_template = settings.pulls_info_url.dup

    # Getting info about issues

    puts "pulls_info_url -> " + info_url_template

    request_url = info_url_template.sub! "#repo_fullname", repo_info.repo_fullname

    total_lines_added = 0
    total_lines_removed = 0
    days_closing_time = 0
    total_comments = 0
    total_review_comments = 0
    total_commits = 0
    total_body_length = 0
    total_title_length = 0
    total_files_changed = 0
    total_labels = 0
    total_closed = 0

    pull_list = []

    page_counter = 0
    while true
      page_counter += 1
      puts "getting page pulls-> " + page_counter.to_s

      response = HTTP[accept: settings.content_type, Authorization: "token #{getNextToken()}"].get(
        request_url + "?per_page=100&page=" + page_counter.to_s, json: {},
      )
      if response.code == 200
        pulls_info = JSON.parse(response)

        if pulls_info.length == 0
          break
        end

        pulls_info.each do |pull|
          response = HTTP[accept: settings.content_type, Authorization: "token #{getNextToken()}"].get(
            pull["url"], json: {},
          )
          if response.code == 200
            p_info = JSON.parse(response)

            total_lines_added += p_info["additions"]
            total_lines_removed += p_info["deletions"]

            total_comments += p_info["comments"]
            total_review_comments += p_info["review_comments"]
            total_commits += p_info["commits"]
            total_body_length += p_info["body"] ? p_info["body"].length : 0
            total_title_length += p_info["title"] ? p_info["title"].length : 0
            total_files_changed += p_info["changed_files"]
            total_labels += p_info["labels"].length
            if p_info["state"] == "closed"
              days_closing_time += (DateTime.parse(p_info["closed_at"]) - DateTime.parse(p_info["created_at"]) / 1.day).round
              total_closed += 1
            end

            pull_list.push(p_info.dup)
          else
            puts JSON.pretty_generate(response.parse)
          end
        end
      else
        puts JSON.pretty_generate(response.parse)
        break
      end
    end

    if pull_list.length > 0
      projectMetrics.pulls_count = pull_list.length
      projectMetrics.pulls_total_lines_added = total_lines_added
      projectMetrics.pulls_total_lines_removed = total_lines_removed
      projectMetrics.pulls_avg_lines_added = total_lines_added / pull_list.length
      projectMetrics.pulls_avg_lines_removed = total_lines_removed / pull_list.length
      projectMetrics.pulls_avg_closing_time = total_closed > 0 ? days_closing_time / total_closed : 0
      projectMetrics.pulls_avg_comments = total_comments / pull_list.length
      projectMetrics.pulls_avg_review_comments = total_review_comments / pull_list.length
      projectMetrics.pulls_avg_Commits = total_commits / pull_list.length
      projectMetrics.pulls_avg_body_length = total_body_length / pull_list.length
      projectMetrics.pulls_avg_title_length = total_title_length / pull_list.length
      projectMetrics.pulls_avg_files_changed = total_files_changed / pull_list.length
      projectMetrics.pulls_avg_labels = total_labels / pull_list.length

      pull_grouped = pull_list.group_by { |i| DateTime.parse(i["created_at"]).beginning_of_day }.sort_by { |x| x[1].length }

      projectMetrics.pulls_max_created_per_day = pull_grouped.last[1].length.to_s
      projectMetrics.pulls_avg_created_per_day = pull_grouped.length / repo_age_days
      projectMetrics.pulls_avg_created_per_day_real = pull_grouped.length / pull_grouped.length
    else
      projectMetrics.pulls_count = 0
      projectMetrics.pulls_total_lines_added = 0
      projectMetrics.pulls_total_lines_removed = 0
      projectMetrics.pulls_avg_lines_added = 0
      projectMetrics.pulls_avg_lines_removed = 0
      projectMetrics.pulls_avg_closing_time = 0
      projectMetrics.pulls_avg_comments = 0
      projectMetrics.pulls_avg_review_comments = 0
      projectMetrics.pulls_avg_Commits = 0
      projectMetrics.pulls_avg_body_length = 0
      projectMetrics.pulls_avg_title_length = 0
      projectMetrics.pulls_avg_files_changed = 0
      projectMetrics.pulls_avg_labels = 0

      projectMetrics.pulls_max_created_per_day = 0
      projectMetrics.pulls_avg_created_per_day = 0
      projectMetrics.pulls_avg_created_per_day_real = 0
    end

    pull_list = nil

    puts "getting releases info for -> " + repo_info.repo_fullname

    info_url_template = settings.releases_info_url.dup

    # Getting info about releases

    puts "releases_info_url -> " + info_url_template

    request_url = info_url_template.sub! "#repo_fullname", repo_info.repo_fullname

    total_releases = 0
    total_tags = 0
    total_assets = 0
    total_assets_downloads = 0
    total_assets_size = 0
    total_body_length = 0
    total_title_length = 0

    releases_list = []

    page_counter = 0
    while true
      page_counter += 1
      puts "getting page release -> " + page_counter.to_s

      response = HTTP[accept: settings.content_type, Authorization: "token #{getNextToken()}"].get(
        request_url + "?per_page=100&page=" + page_counter.to_s, json: {},
      )
      if response.code == 200
        releases_info = JSON.parse(response)

        if releases_info.length == 0
          break
        end
        total_releases += releases_info.length
        releases_info.each do |release|
          total_assets += release["assets"].length
          release["assets"].each do |a|
            total_assets_downloads += a["download_count"]
            total_assets_size += a["size"] ? a["size"] : 0
          end
          if release["tag_name"]
            total_tags += 1
          end
          total_body_length += release["body"].length
          total_title_length += release["name"].length
        end
      else
        puts JSON.pretty_generate(response.parse)
        break
      end
    end

    if total_releases > 0
      projectMetrics.releases_count = total_releases
      projectMetrics.releases_tags = total_tags
      projectMetrics.releases_total_downloads = total_assets_downloads
      projectMetrics.releases_avg_body_length = total_body_length / total_releases
      projectMetrics.releases_avg_title_length = total_title_length / total_releases
      projectMetrics.releases_avg_assets = total_assets / total_releases
      projectMetrics.releases_avg_assets_downloads = total_assets > 0 ? total_assets_downloads / total_assets : 0
      projectMetrics.releases_avg_assets_size = total_assets > 0 ? total_assets_size / total_assets : 0
    else
      projectMetrics.releases_count = 0
      projectMetrics.releases_tags = 0
      projectMetrics.releases_total_downloads = 0
      projectMetrics.releases_avg_body_length = 0
      projectMetrics.releases_avg_title_length = 0
      projectMetrics.releases_avg_assets = 0
      projectMetrics.releases_avg_assets_downloads = 0
      projectMetrics.releases_avg_assets_size = 0
    end
    releases_list = nil

    puts "getting stars info for -> " + repo_info.repo_fullname

    info_url_template = settings.stars_info_url.dup

    # Getting info about stars

    puts "stars_info_url -> " + info_url_template

    request_url = info_url_template.sub! "#repo_fullname", repo_info.repo_fullname

    total_stars = 0
    stars_list = []

    page_counter = 0
    while true
      page_counter += 1
      puts "getting page stars-> " + page_counter.to_s

      response = HTTP[accept: "application/vnd.github.v3.star+json", Authorization: "token #{getNextToken()}"].get(
        request_url + "?per_page=100&page=" + page_counter.to_s, json: {},
      )
      if response.code == 200
        stars_info = JSON.parse(response)

        if stars_info.length == 0
          break
        end
        total_stars += stars_info.length
        stars_list.concat stars_info
      else
        puts JSON.pretty_generate(response.parse)
        break
      end
    end

    if total_stars > 0
      stars_grouped = stars_list.group_by { |i| DateTime.parse(i["starred_at"]).beginning_of_day }.sort_by { |x| x[1].length }
      projectMetrics.stars_count = total_stars
      projectMetrics.stars_avg_per_day_real = total_stars / stars_grouped.length
      projectMetrics.stars_max_per_day = stars_grouped.last[1].length.to_s
    else
      projectMetrics.stars_count = 0
      projectMetrics.stars_avg_per_day_real = 0
      projectMetrics.stars_max_per_day = 0
    end

    stars_list = nil

    puts "getting workflows info for -> " + repo_info.repo_fullname

    info_url_template = settings.workflows_info_url.dup

    # Getting info about workflows

    puts "workflows_info_url -> " + info_url_template

    request_url = info_url_template.sub! "#repo_fullname", repo_info.repo_fullname

    total_runs = 0
    total_duration = 0
    total_success_duration = 0
    total_failure_duration = 0
    workflows_success_list = []
    workflows_fail_list = []

    page_counter = 0
    while true
      page_counter += 1
      puts "getting page wf -> " + page_counter.to_s

      response = HTTP[accept: settings.content_type, Authorization: "token #{getNextToken()}"].get(
        request_url + "?per_page=100&page=" + page_counter.to_s, json: {},
      )
      if response.code == 200
        workflows_info = JSON.parse(response)
        if workflows_info["workflow_runs"].length == 0
          break
        end
        total_runs += workflows_info.length
        workflows_info["workflow_runs"].each do |w|
          if w["conclusion"] == "success"
            workflows_success_list.push(w)
            # time in seconds
            total_success_duration += DateTime.parse(w["updated_at"]) - DateTime.parse(w["run_started_at"])
          else
            workflows_fail_list.push(w)
            # time in seconds
            total_failure_duration += DateTime.parse(w["updated_at"]) - DateTime.parse(w["run_started_at"])
          end
          total_duration += DateTime.parse(w["updated_at"]) - DateTime.parse(w["run_started_at"])
        end
      else
        puts JSON.pretty_generate(response.parse)
        break
      end
    end

    if total_runs > 0
      projectMetrics.wf_count = total_runs
      projectMetrics.wf_avg_duration = total_duration / total_runs
      projectMetrics.wf_avg_success_duration = total_success_duration / total_runs
      projectMetrics.wf_avg_failure_duration = total_failure_duration / total_runs
      success_grouped = workflows_success_list.group_by { |i| DateTime.parse(i["created_at"]).beginning_of_day }.sort_by { |x| x[1].length }
      projectMetrics.wf_avg_successes_per_day = (total_runs / repo_age_days)
      if success_grouped.length > 0
        projectMetrics.wf_avg_successes_per_day_real = (workflows_success_list.length / success_grouped.length)
      else
        projectMetrics.wf_avg_successes_per_day_real = 0
      end
      projectMetrics.wf_avg_fails_per_day = (workflows_fail_list.length / repo_age_days)
    else
      projectMetrics.wf_count = 0
      projectMetrics.wf_avg_duration = 0
      projectMetrics.wf_avg_success_duration = 0
      projectMetrics.wf_avg_failure_duration = 0
      projectMetrics.wf_avg_successes_per_day = 0
      projectMetrics.wf_avg_successes_per_day_real = 0
      projectMetrics.wf_avg_fails_per_day = 0
    end

    workflows_success_list = nil
    workflows_fail_list = nil

    projectMetrics.save
  end

  def get_last_update(json)
    puts "getting last update GithubRadar"

    pushInfo = TomPushInfo.new()
    pushInfo.head_commit_id = json["head_commit"]["id"]
    pushInfo.repo_name = json["repository"]["name"]
    pushInfo.full_name = json["repository"]["full_name"]
    pushInfo.isFork = json["repository"]["fork"]
    pushInfo.open_issues_count = json["repository"]["open_issues_count"]
    pushInfo.size = json["repository"]["size"]
    pushInfo.language = json["repository"]["language"]
    pushInfo.repo_url = json["repository"]["clone_url"]
    pushInfo.commits_count = json["commits"].length
    pushInfo.status = "P"

    total_added = 0
    total_removed = 0
    total_changed = 0
    json["commits"].each do |commit|
      total_added += commit["added"].length
      total_removed += commit["removed"].length
      total_changed += commit["modified"].length
    end
    pushInfo.total_files_added = total_added
    pushInfo.total_files_removed = total_removed
    pushInfo.total_files_changed = total_changed

    puts pushInfo.inspect

    if pushInfo.save
      repo_name = json["repository"]["full_name"]
      issue_body =
        "TOM has finished to check you code and it has found these anomalies:
      - The overall scope of the project, a development stage or a particular activity, has been miscalculated.[#TOM-A001]

      TOM has finished to check you code and it would like to advise you with some actions:
      - #capa-1
      - #capa-2"

      capas = [
        "review and improve staff training procedures [#TOM-C001]",
        "replan project and re-estimate targets [#TOM-C002]",
        "review and improve estimating procedures [#TOM-C003]",
        "review and improve project working procedures [#TOM-C004]",
        "if the scope of the project has been underestimated, obtain more experienced staff [#TOM-C005]",
        "if the scope has been overestimated, release experienced staff to other projects [#TOM-C006]",
        "stop current work and revert to activities of preceding stage [#TOM-C007]",
        "extend activities of previous stage into current stage, replanning effort and work assignment [#TOM-C008]",
        "extend timescales for testing and debugging current stage because of anticipated additional latent faults from previous stage [#TOM-C009]",
        "review and improve criteria for entry to, and exit from, stages and activities [#TOM-C010]",
        "redesign the module into smaller components [#TOM-C011]",
        "extend the timescales for testing the module [#TOM-C012]",
      ]

      issue_body.sub! "#capa-1", capas.sample
      issue_body.sub! "#capa-2", capas.sample

      activation = TomRadarActivation.new(
        source: SOURCE,
        issuetitle: "TOM Findings ##{repo_name}",
        issuebody: issue_body,
        status: "Pending",
        request_body: json,
      )

      if activation.save
        return true
      else
        return false
      end
    else
      return false
    end
  end

  def getSourceCode()
    # downloading those repositories that have been recently updated
    TomPushInfo.where(status: "P").each do |pushInfo|
      dir_name = "./tmp/github_" + pushInfo.head_commit_id
      # Creating a temporal folder where the repository will be cloned
      Dir.mkdir(dir_name) unless Dir.exists?(dir_name)
      begin
        g = Git.clone(pushInfo.repo_url, pushInfo.repo_name, :path => dir_name)
      rescue Exception => e
        puts "--- error catched ---"
        puts e.message
      end
      # updating the status to pass next stage, prepare the repo and run sonarqube analysis
      pushInfo.status = "D"
      pushInfo.save

      puts pushInfo.inspect
      break
    end
  end

  def getNextToken()
    @@call_count += 1
    next_token_index = (@@call_count % @@Tokens.length)
    puts "call count -> " + @@call_count.to_s
    puts "tokens count -> " + @@Tokens.length.to_s
    puts "index -> " + next_token_index.to_s
    puts "token -> " + @@Tokens[next_token_index].token
    return @@Tokens[next_token_index].token
  end
end
