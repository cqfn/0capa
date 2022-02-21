# frozen_string_literal: true
require_rel "../../ml_model/"

class Api::V1::AdvisorController < ApplicationController
  @@Model_trained = nil

  def train
    model_name = params[:model].capitalize
    ml_model = FactoryClass.create("#{model_name}Model", nil)
    @@Model_trained = ml_model.train()

    if @@Model_trained.nil?
      render json: { error: "Model not trained" }, status: 400
    else
      render json: { message: "Model trained sucessfully" }, status: 200
    end
  end

  def predict
    if @@Model_trained.nil?
      render json: { error: "Model not trained" }, status: 400
    else
      sql = "select *
            from tom_project_metrics m
            where m.id not in (
              select p.analysis_id
              from tom_project_capa_predictions p
            )"

      TomProjectMetric.find_by_sql([sql]).each do |row|
        # puts row.repo_fullname

        predicted = @@Model_trained.predict [[
          row.commits_count,
          row.commits_days_since_first,
          row.commits_days_since_last,
          row.commits_total_lines_added,
          row.commits_total_lines_removed,
          row.commits_avg_added,
          row.commits_avg_removed,
          row.commits_avg_files_changed,
          row.commits_avg_message_length,
          row.commits_avg_per_day,
          row.commits_avg_per_day_real,
          row.commits_max_per_day,
          row.contributors_count,
          row.contributors_top_avg_commits,
          row.contributors_top_avg_participation_week,
          row.contributors_top_avg_additions,
          row.contributors_top_avg_deletions,
          row.forks_count,
          row.forks_avg_per_day,
          row.forks_avg_max_per_day,
          row.issues_total_comments,
          row.issues_count,
          row.issues_open,
          row.issues_labels,
          row.issues_avg_labels,
          row.issues_avg_closing_time,
          row.issues_avg_comment_time,
          row.issues_avg_comments,
          row.issues_avg_comment_length,
          row.issues_avg_title_length,
          row.issues_avg_body_length,
          row.issues_avg_per_day,
          row.issues_avg_per_day_real,
          row.issues_max_per_day,
          row.repo_size,
          row.repo_topics,
          row.repo_branches,
          row.repo_age_days,
          row.repo_workflows,
          row.repo_languages,
          row.repo_milestones,
          row.repo_watchers,
          row.repo_deployments,
          row.repo_readme_length,
          row.repo_network_members,
          row.pulls_count,
          row.pulls_total_lines_added,
          row.pulls_total_lines_removed,
          row.pulls_avg_lines_added,
          row.pulls_avg_lines_removed,
          row.pulls_avg_closing_time,
          row.pulls_avg_comments,
          row.pulls_avg_review_comments,
          row.pulls_avg_Commits,
          row.pulls_avg_body_length,
          row.pulls_avg_title_length,
          row.pulls_avg_files_changed,
          row.pulls_avg_labels,
          row.pulls_avg_created_per_day,
          row.pulls_avg_created_per_day_real,
          row.pulls_max_created_per_day,
          row.releases_count,
          row.releases_tags,
          row.releases_total_downloads,
          row.releases_avg_body_length,
          row.releases_avg_title_length,
          row.releases_avg_assets,
          row.releases_avg_assets_downloads,
          row.releases_avg_assets_size,
          row.releases_avg_downloads_per_day,
          row.stars_count,
          row.stars_avg_per_day_real,
          row.stars_max_per_day,
          row.wf_count,
          row.wf_avg_duration,
          row.wf_avg_success_duration,
          row.wf_avg_failure_duration,
          row.wf_avg_successes_per_day,
          row.wf_avg_successes_per_day_real,
          row.wf_avg_fails_per_day,
        ]]
        # puts JSON.pretty_generate(predicted)
        # puts predicted
        puts row.repo_fullname
        if predicted[0] != 0
          puts "\nClosest cluster to #{row.repo_fullname}: case #{predicted[0]}"

          capa_predicted = TomProjectCapaPrediction.new(
            analysis_id: row.id,
            repo_fullname: row.repo_fullname,
            label: "case_#{predicted[0]}",
            status: "N", # New

          )
          capa_predicted.save
        end
      end

      render json: { message: "Model trained" }, status: 200
    end
  end
end
