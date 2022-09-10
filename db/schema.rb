# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_220_617_084_859) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'tom_analyses', force: :cascade do |t|
    t.string 'extractor_id'
    t.string 'repo_name'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'tom_analysis_metrics', force: :cascade do |t|
    t.string 'analysis_id'
    t.string 'metric_name'
    t.string 'value'
    t.string 'is_best_value'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'tom_capa_dictonaries', force: :cascade do |t|
    t.string 'case_id'
    t.string 'description'
    t.string 'category'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'tom_commits_metrics', force: :cascade do |t|
    t.string 'repoid'
    t.string 'full_name'
    t.string 'repo_name'
    t.string 'base_commit_id'
    t.string 'head_commit_id'
    t.string 'diff_url'
    t.string 'status'
    t.integer 'commits_count'
    t.integer 'total_files'
    t.integer 'total_files_added'
    t.integer 'total_files_removed'
    t.integer 'total_files_changed'
    t.integer 'total_added'
    t.integer 'total_removed'
    t.integer 'total_changed'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.datetime 'commit_datetime'
    t.integer 'message_length'
    t.index ['full_name'], name: 'index_tom_commits_metrics_on_full_name'
  end

  create_table 'tom_fork_infos', force: :cascade do |t|
    t.string 'repoid'
    t.string 'repo_fullname'
    t.string 'folk_id'
    t.string 'folk_fullname'
    t.string 'owner'
    t.string 'is_private'
    t.datetime 'created_at_ext'
    t.datetime 'updated_at_ext'
    t.datetime 'pushed_at_ext'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'tom_git_user_infos', force: :cascade do |t|
    t.string 'user_id'
    t.string 'user_login'
    t.integer 'followers_counter'
    t.integer 'following_counter'
    t.integer 'orgs_counter'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'tom_issues', force: :cascade do |t|
    t.string 'issueid'
    t.string 'repo_issueid'
    t.datetime 'created_at_ext'
    t.integer 'comments'
    t.datetime 'closed_at_ext'
    t.string 'closed_by'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'tom_issues_comments', force: :cascade do |t|
    t.string 'repoid'
    t.string 'repo_fullname'
    t.string 'comment_ext_id'
    t.string 'comment_created_by'
    t.string 'comment_created_at'
    t.string 'comment_updated_at'
    t.string 'author_association'
    t.string 'body'
    t.string 'body_len'
    t.integer 'total_reactions_counter'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'tom_issues_infos', force: :cascade do |t|
    t.string 'repoid'
    t.string 'repo_fullname'
    t.string 'issue_id'
    t.string 'issue_number'
    t.string 'title'
    t.string 'created_by_ext'
    t.string 'labels'
    t.integer 'labels_count'
    t.string 'state'
    t.integer 'asssigned_count'
    t.string 'milestone_title'
    t.datetime 'created_at_ext'
    t.datetime 'updated_at_ext'
    t.datetime 'closed_at_ext'
    t.integer 'comments_count'
    t.string 'author_association'
    t.integer 'body_length'
    t.integer 'reactions_count'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'tom_pr_comments', force: :cascade do |t|
    t.string 'repoid'
    t.string 'repo_fullname'
    t.string 'comment_ext_id'
    t.string 'comment_created_by'
    t.string 'comment_created_at'
    t.string 'comment_updated_at'
    t.string 'author_association'
    t.string 'body'
    t.string 'body_len'
    t.integer 'total_reactions_counter'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'tom_project_capa_predictions', force: :cascade do |t|
    t.integer 'analysis_id'
    t.string 'repo_fullname'
    t.string 'label'
    t.string 'status'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'tom_project_metrics', force: :cascade do |t|
    t.string 'repo_fullname'
    t.integer 'commits_count'
    t.integer 'commits_days_since_first'
    t.integer 'commits_days_since_last'
    t.integer 'commits_total_lines_added'
    t.integer 'commits_total_lines_removed'
    t.float 'commits_avg_added'
    t.float 'commits_avg_removed'
    t.float 'commits_avg_files_changed'
    t.float 'commits_avg_message_length'
    t.float 'commits_avg_per_day'
    t.float 'commits_avg_per_day_real'
    t.integer 'commits_max_per_day'
    t.integer 'contributors_count'
    t.float 'contributors_top_avg_commits'
    t.float 'contributors_top_avg_participation_week'
    t.float 'contributors_top_avg_additions'
    t.float 'contributors_top_avg_deletions'
    t.integer 'forks_count'
    t.float 'forks_avg_per_day'
    t.float 'forks_avg_max_per_day'
    t.integer 'issues_total_comments'
    t.integer 'issues_count'
    t.integer 'issues_open'
    t.integer 'issues_labels'
    t.float 'issues_avg_labels'
    t.float 'issues_avg_closing_time'
    t.float 'issues_avg_comment_time'
    t.float 'issues_avg_comments'
    t.float 'issues_avg_comment_length'
    t.float 'issues_avg_title_length'
    t.float 'issues_avg_body_length'
    t.float 'issues_avg_per_day'
    t.float 'issues_avg_per_day_real'
    t.float 'issues_max_per_day'
    t.integer 'repo_size'
    t.integer 'repo_topics'
    t.integer 'repo_branches'
    t.integer 'repo_age_days'
    t.integer 'repo_workflows'
    t.integer 'repo_languages'
    t.integer 'repo_milestones'
    t.integer 'repo_watchers'
    t.integer 'repo_deployments'
    t.integer 'repo_readme_length'
    t.integer 'repo_network_members'
    t.integer 'pulls_count'
    t.integer 'pulls_total_lines_added'
    t.integer 'pulls_total_lines_removed'
    t.float 'pulls_avg_lines_added'
    t.float 'pulls_avg_lines_removed'
    t.float 'pulls_avg_closing_time'
    t.float 'pulls_avg_comments'
    t.float 'pulls_avg_review_comments'
    t.float 'pulls_avg_Commits'
    t.float 'pulls_avg_body_length'
    t.float 'pulls_avg_title_length'
    t.float 'pulls_avg_files_changed'
    t.float 'pulls_avg_labels'
    t.float 'pulls_avg_created_per_day'
    t.float 'pulls_avg_created_per_day_real'
    t.integer 'pulls_max_created_per_day'
    t.integer 'releases_count'
    t.integer 'releases_tags'
    t.integer 'releases_total_downloads'
    t.float 'releases_avg_body_length'
    t.float 'releases_avg_title_length'
    t.float 'releases_avg_assets'
    t.float 'releases_avg_assets_downloads'
    t.float 'releases_avg_assets_size'
    t.float 'releases_avg_downloads_per_day'
    t.integer 'stars_count'
    t.float 'stars_avg_per_day_real'
    t.integer 'stars_max_per_day'
    t.integer 'wf_count'
    t.float 'wf_avg_duration'
    t.float 'wf_avg_success_duration'
    t.float 'wf_avg_failure_duration'
    t.float 'wf_avg_successes_per_day'
    t.float 'wf_avg_successes_per_day_real'
    t.float 'wf_avg_fails_per_day'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['repo_fullname'], name: 'index_tom_project_metrics_on_repo_fullname'
  end

  create_table 'tom_project_metrics_trains', force: :cascade do |t|
    t.string 'repo_fullname'
    t.integer 'commits_count'
    t.integer 'commits_days_since_first'
    t.integer 'commits_days_since_last'
    t.integer 'commits_total_lines_added'
    t.integer 'commits_total_lines_removed'
    t.float 'commits_avg_added'
    t.float 'commits_avg_removed'
    t.float 'commits_avg_files_changed'
    t.float 'commits_avg_message_length'
    t.float 'commits_avg_per_day'
    t.float 'commits_avg_per_day_real'
    t.integer 'commits_max_per_day'
    t.integer 'contributors_count'
    t.float 'contributors_top_avg_commits'
    t.float 'contributors_top_avg_participation_week'
    t.float 'contributors_top_avg_additions'
    t.float 'contributors_top_avg_deletions'
    t.integer 'forks_count'
    t.float 'forks_avg_per_day'
    t.float 'forks_avg_max_per_day'
    t.integer 'issues_total_comments'
    t.integer 'issues_count'
    t.integer 'issues_open'
    t.integer 'issues_labels'
    t.float 'issues_avg_labels'
    t.float 'issues_avg_closing_time'
    t.float 'issues_avg_comment_time'
    t.float 'issues_avg_comments'
    t.float 'issues_avg_comment_length'
    t.float 'issues_avg_title_length'
    t.float 'issues_avg_body_length'
    t.float 'issues_avg_per_day'
    t.float 'issues_avg_per_day_real'
    t.float 'issues_max_per_day'
    t.integer 'repo_size'
    t.integer 'repo_topics'
    t.integer 'repo_branches'
    t.integer 'repo_age_days'
    t.integer 'repo_workflows'
    t.integer 'repo_languages'
    t.integer 'repo_milestones'
    t.integer 'repo_watchers'
    t.integer 'repo_deployments'
    t.integer 'repo_readme_length'
    t.integer 'repo_network_members'
    t.integer 'pulls_count'
    t.integer 'pulls_total_lines_added'
    t.integer 'pulls_total_lines_removed'
    t.float 'pulls_avg_lines_added'
    t.float 'pulls_avg_lines_removed'
    t.float 'pulls_avg_closing_time'
    t.float 'pulls_avg_comments'
    t.float 'pulls_avg_review_comments'
    t.float 'pulls_avg_Commits'
    t.float 'pulls_avg_body_length'
    t.float 'pulls_avg_title_length'
    t.float 'pulls_avg_files_changed'
    t.float 'pulls_avg_labels'
    t.float 'pulls_avg_created_per_day'
    t.float 'pulls_avg_created_per_day_real'
    t.integer 'pulls_max_created_per_day'
    t.integer 'releases_count'
    t.integer 'releases_tags'
    t.integer 'releases_total_downloads'
    t.float 'releases_avg_body_length'
    t.float 'releases_avg_title_length'
    t.float 'releases_avg_assets'
    t.float 'releases_avg_assets_downloads'
    t.float 'releases_avg_assets_size'
    t.float 'releases_avg_downloads_per_day'
    t.integer 'stars_count'
    t.float 'stars_avg_per_day_real'
    t.integer 'stars_max_per_day'
    t.integer 'wf_count'
    t.float 'wf_avg_duration'
    t.float 'wf_avg_success_duration'
    t.float 'wf_avg_failure_duration'
    t.float 'wf_avg_successes_per_day'
    t.float 'wf_avg_successes_per_day_real'
    t.float 'wf_avg_fails_per_day'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.string 'data_label'
  end

  create_table 'tom_projects', force: :cascade do |t|
    t.string 'name'
    t.string 'description'
    t.string 'isactive'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.string 'repo_fullname'
    t.string 'repo_url'
    t.string 'repoid'
    t.string 'invitation_id'
    t.string 'inviter_login'
    t.string 'permissions'
    t.string 'is_private'
    t.string 'owner_login'
    t.string 'last_commit_id'
    t.datetime 'last_scanner_date'
    t.string 'source'
    t.datetime 'repo_created_at'
    t.string 'last_analysis_time_elapsed'
    t.string 'status'
    t.string 'node_name'
    t.string 'is_archived'
  end

  create_table 'tom_pull_infos', force: :cascade do |t|
    t.string 'repoid'
    t.string 'repo_fullname'
    t.string 'pull_id'
    t.string 'pull_number'
    t.string 'state'
    t.string 'title'
    t.string 'title_length'
    t.string 'owner'
    t.string 'body_length'
    t.datetime 'created_at_ext'
    t.datetime 'updated_at_ext'
    t.datetime 'closed_at_ext'
    t.datetime 'merged_at_ext'
    t.integer 'asssigned_count'
    t.integer 'req_review_count'
    t.string 'labels'
    t.integer 'labels_count'
    t.string 'milestone_title'
    t.string 'author_association'
    t.string 'head_commit_id'
    t.string 'base_commit_id'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.integer 'commits_counts'
    t.string 'is_locked'
    t.integer 'code_blocks_counter'
    t.string 'links_counter'
  end

  create_table 'tom_push_infos', force: :cascade do |t|
    t.string 'head_commit_id'
    t.string 'full_name'
    t.string 'isFork'
    t.integer 'open_issues_count'
    t.string 'size'
    t.string 'language'
    t.integer 'commits_count'
    t.integer 'total_files_added'
    t.integer 'total_files_removed'
    t.integer 'total_files_changed'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.string 'repo_name'
    t.string 'repo_url'
    t.string 'status', default: 'P'
  end

  create_table 'tom_radar_activations', force: :cascade do |t|
    t.string 'source'
    t.string 'issuetitle'
    t.string 'issuebody'
    t.string 'status'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.json 'request_body'
  end

  create_table 'tom_release_infos', force: :cascade do |t|
    t.string 'repoid'
    t.string 'repo_fullname'
    t.string 'release_id'
    t.string 'author'
    t.string 'name'
    t.datetime 'created_at_ext'
    t.datetime 'published_at_ext'
    t.integer 'assets_count'
    t.integer 'body_length'
    t.integer 'reactions_count'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'tom_settings', force: :cascade do |t|
    t.string 'agentname'
    t.string 'accesstokenendpoint'
    t.string 'authorizationbaseurl'
    t.string 'requesttokenendpoint'
    t.string 'authenticationmethod'
    t.string 'apikey'
    t.string 'apisecret'
    t.string 'isactive'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.string 'invitations_endpoint'
    t.string 'invitations_accept_endpoint'
    t.string 'notifications_endpoint'
    t.string 'content_type'
    t.string 'repos_info_url'
    t.string 'repos_diff_url'
    t.string 'commits_info_url'
    t.string 'contributors_info_url'
    t.string 'forks_info_url'
    t.string 'issues_info_url'
    t.string 'pulls_info_url'
    t.string 'releases_info_url'
    t.string 'stars_info_url'
    t.string 'workflows_info_url'
    t.string 'issues_Comments_info_url'
    t.string 'node_name'
  end

  create_table 'tom_tokens_queues', force: :cascade do |t|
    t.string 'token'
    t.string 'source'
    t.string 'owner'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.string 'isactive', default: 'Y'
  end

  create_table 'tom_workflow_infos', force: :cascade do |t|
    t.string 'repoid'
    t.string 'repo_fullname'
    t.string 'action_id'
    t.string 'name'
    t.string 'action_number'
    t.string 'event'
    t.string 'status'
    t.string 'conclusion'
    t.string 'workflow_id'
    t.integer 'run_attempt_count'
    t.datetime 'created_at_ext'
    t.datetime 'updated_at_ext'
    t.datetime 'started_at_ext'
    t.string 'actor'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end
end
