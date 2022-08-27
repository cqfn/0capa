# frozen_string_literal: true

class CreateTomGitUserInfos < ActiveRecord::Migration[6.1]
  def change
    create_table :tom_git_user_infos do |t|
      t.string :user_id
      t.string :user_login
      t.integer :followers_counter
      t.integer :following_counter
      t.integer :orgs_counter
      t.timestamps
    end
  end
end
