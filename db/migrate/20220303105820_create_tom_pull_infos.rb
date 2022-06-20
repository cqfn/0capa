class CreateTomPullInfos < ActiveRecord::Migration[6.1]
  def change
    create_table :tom_pull_infos do |t|
      t.string :repoid
      t.string :repo_fullname
      t.string :pull_id
      t.string :pull_number
      t.string :state
      t.string :title
      t.string :title_length
      t.string :owner
      t.string :body_length
      t.datetime :created_at_ext
      t.datetime :updated_at_ext
      t.datetime :closed_at_ext
      t.datetime :merged_at_ext
      t.integer :asssigned_count
      t.integer :req_review_count
      t.string :labels
      t.integer :labels_count
      t.string :milestone_title
      t.string :author_association
      t.string :head_commit_id
      t.string :base_commit_id
      t.timestamps
    end
  end
end
