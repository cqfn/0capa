# frozen_string_literal: false

require "json"
require "git"
require "fileutils"

require_relative "radar_base_controller"

class GithubRadar < RadarBaseController
  SORUCE = "github"

  def initialize
    puts "initialize GithubRadar"
    Initialize(SORUCE)
  end

  def check_new_invitations()
    settings = TomSetting.find_by(agentname: SORUCE)

    response = HTTP[accept: settings.content_type, Authorization: "token #{settings.apisecret}"].get(
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
            source: SORUCE,
            isactive: "Y",
          )
          accept_url = settings.invitations_accept_endpoint.sub! "#invitation_id", invitation["id"].to_s

          invitation_response = HTTP[accept: settings.content_type, Authorization: "token #{settings.apisecret}"].patch(
            accept_url, json: {},
          )
          puts "invitation_response -> " + invitation_response.code.to_s
          if invitation_response.code == 204
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
    settings = TomSetting.find_by(agentname: SORUCE)

    # https://api.github.com/repos/#repo_fullname
    info_url_template = settings.repos_info_url

    puts "info_url_template -> " + info_url_template

    TomProject.where(source: SORUCE).each do |project|
      last_commit = ""
      puts "repo_fullname -> " + project.repo_fullname

      request_url = info_url_template.sub! "#repo_fullname", project.repo_fullname

      if project.last_commit_id.nil?
        response = HTTP[accept: settings.content_type, Authorization: "token #{settings.apisecret}"].get(
          request_url, json: {},
        )
      else
        response = HTTP[accept: settings.content_type, Authorization: "token #{settings.apisecret}", sha: project.last_commit_id].get(
          request_url, json: {},
        )
      end

      # puts JSON.pretty_generate(response.parse[0])

      if response.code == 200
        commits = JSON.parse(response)

        if project.last_commit_id.nil?
          puts "no last commit found!!"
          last_commit = commits[0]["sha"]
          project.last_commit_id = last_commit
          project.save
        else
          puts "last commit -> " + project.last_commit_id
          last_commit = project.last_commit_id
        end

        newest_commit = commits.last

        if project.last_commit_id != newest_commit["sha"]
          puts "There is something new"

          request_url = settings.repos_diff_url

          request_url = request_url.sub! "#repo_fullname", project.repo_fullname
          request_url = request_url.sub! "#base_commit_id", newest_commit["sha"]
          request_url = request_url.sub! "#head_commit_id", project.last_commit_id

          response = HTTP[accept: settings.content_type, Authorization: "token #{settings.apisecret}"].get(
            request_url, json: {},
          )
          if response.code == 200
            diff_response = JSON.parse(response)
            total_files_added = 0
            total_files_removed = 0
            total_files_changed = 0

            total_added = 0
            total_removed = 0
            total_changed = 0

            diff_response["files"].each do |file|
              total_added += file["additions"]
              total_removed += file["deletions"]
              total_changed += file["changes"]
            end

            commits.each do |commit|
              response = HTTP[accept: settings.content_type, Authorization: "token #{settings.apisecret}"].get(
                commit["url"], json: {},
              )
              if response.code == 200
                commit_info = JSON.parse(response)
                if !commit_info["stats"].nil?
                  total_files_added += commit_info["stats"]["additions"]
                  total_files_removed += commit_info["stats"]["deletions"]
                  total_files_changed += commit_info["stats"]["total"]
                end
              end
            end

            repoUpdate = TomCommitsMetric.new(
              repoid: project.repoid,
              full_name: project.repo_fullname,
              repo_name: project.name,
              base_commit_id: newest_commit["sha"][0..6],
              head_commit_id: project.last_commit_id[0..6],
              diff_url: diff_response["diff_url"],
              status: diff_response["status"],
              commits_count: diff_response["total_commits"],
              total_files: diff_response["files"].size,
              total_files_added: total_files_added,
              total_files_removed: total_files_removed,
              total_files_changed: total_files_changed,
              total_added: total_added,
              total_removed: total_removed,
              total_changed: total_changed,
            )
            repoUpdate.save

            project.last_commit_id = newest_commit["sha"]

            project.save
            return true
          else
            return false
          end
        else
          puts "There is no new information!!"
          return true
        end
      else
        return false
      end
    end
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
        source: SORUCE,
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
end
