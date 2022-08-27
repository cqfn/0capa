# frozen_string_literal: true

class CreateTomIssuesInfos < ActiveRecord::Migration[6.1]
  def change
    create_table :tom_issues_infos do |t|
      t.string :repoid
      t.string :repo_fullname
      t.string :issue_id
      t.string :issue_number
      t.string :title
      t.string :created_by_ext
      t.string :labels
      t.integer :labels_count
      t.string :state
      t.integer :asssigned_count
      t.string :milestone_title
      t.datetime :created_at_ext
      t.datetime :updated_at_ext
      t.datetime :closed_at_ext
      t.integer :comments_count
      t.string :author_association
      t.integer :body_length
      t.integer :reactions_count

      t.timestamps
    end
  end
end
