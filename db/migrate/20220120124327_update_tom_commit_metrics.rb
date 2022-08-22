# frozen_string_literal: true

class UpdateTomCommitMetrics < ActiveRecord::Migration[6.1]
  def change
    add_column :tom_commits_metrics, :commit_datetime, :datetime
    add_column :tom_commits_metrics, :message_length, :integer
    add_index :tom_commits_metrics, :full_name
    add_index :tom_project_metrics, :repo_fullname
  end
end
