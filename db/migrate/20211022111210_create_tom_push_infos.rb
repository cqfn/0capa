class CreateTomPushInfos < ActiveRecord::Migration[6.1]
  def change
    create_table :tom_push_infos do |t|
      t.string :repoid
      t.string :full_name
      t.string :isFork
      t.integer :open_issues_count
      t.string :size
      t.string :language
      t.integer :commits_count
      t.integer :total_files_added
      t.integer :total_files_removed
      t.integer :total_files_changed

      t.timestamps
    end
  end
end
