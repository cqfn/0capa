class CreateTomPrComments < ActiveRecord::Migration[6.1]
  def change
    create_table :tom_pr_comments do |t|
      t.string :repoid
      t.string :repo_fullname
      t.string :comment_ext_id
      t.string :comment_created_by
      t.string :comment_created_at
      t.string :comment_updated_at
      t.string :author_association
      t.string :body
      t.string :body_len
      t.integer :total_reactions_counter
      t.timestamps
    end
  end
end
