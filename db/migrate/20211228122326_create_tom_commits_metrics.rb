# frozen_string_literal: true

class CreateTomCommitsMetrics < ActiveRecord::Migration[6.1]
  def change
    create_table :tom_commits_metrics do |t|
      t.string :repoid
      t.string :full_name
      t.string :repo_name
      t.string :base_commit_id
      t.string :head_commit_id
      t.string :diff_url
      t.string :status
      t.integer :commits_count
      t.integer :total_files
      t.integer :total_files_added
      t.integer :total_files_removed
      t.integer :total_files_changed
      t.integer :total_added
      t.integer :total_removed
      t.integer :total_changed
      t.timestamps
    end
  end
end
