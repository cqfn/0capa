# frozen_string_literal: false

require "json"
require_relative "base_radar_controller"

class GithubRadar < RadarBaseController
  SORUCE = "github"

  def initialize
    puts "initialize GithubRadar"
    _Initialize(SORUCE)
  end

  def get_last_update(json)
    puts "getting last update GithubRadar"

    pushInfo = TomPushInfo.new()
    pushInfo.repoid = json["repository"]["id"]
    pushInfo.full_name = json["repository"]["full_name"]
    pushInfo.isFork = json["repository"]["fork"]
    pushInfo.open_issues_count = json["repository"]["open_issues_count"]
    pushInfo.size = json["repository"]["size"]
    pushInfo.language = json["repository"]["language"]
    pushInfo.commits_count = json["commits"].length

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
end
