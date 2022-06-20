class CreateTomIssues < ActiveRecord::Migration[6.1]
  def change
    create_table :tom_issues do |t|
      t.string :issueid
      t.string :repo_issueid
      t.timestamp :created_at_ext
      t.integer :comments
      t.timestamp :closed_at_ext
      t.string :closed_by

      t.timestamps
    end
  end
end
