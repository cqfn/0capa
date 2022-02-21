# frozen_string_literal: true

#TODO: implement the class methods
require "json"
require "kmeans-clusterer"
require_relative "model_base_controller"

class KmeansModel < ModelBaseController
  def initialize
    puts "initialize kmeans model"
    Initialize("kmeans")
  end

  def train()
    labels = []
    data = []
    training_set = TomProjectMetricsTrain.all

    if training_set.length > 0
      training_set.each do |row|
        # puts row.repo_fullname
        labels.push(row.data_label)
        data.push([
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
        ])
      end

      k = 10
      kmeans = KMeansClusterer.run k, data, labels: labels, runs: 1000
      puts "Clusters: #{k}, Error: #{kmeans.error.round(2)}"
      # kmeans = nil
      # 2.upto(180) do |k|
      #   kmeans = KMeansClusterer.run k, data, labels: labels, runs: 100
      #   puts "Clusters: #{k}, Error: #{kmeans.error.round(2)}"
      # end

      kmeans.clusters.each do |cluster|
        puts "Cluster #{cluster.id}"
        puts "Center of Cluster: #{cluster.centroid}"
        puts "Cities in Cluster: " + cluster.points.map { |c| c.label }.join(",")
      end

      return kmeans
    else
      puts "No data to train"
      return false
    end
  end
end
