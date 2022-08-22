# frozen_string_literal: true

class CreateTomReleaseInfos < ActiveRecord::Migration[6.1]
  def change
    create_table :tom_release_infos do |t|
      t.string :repoid
      t.string :repo_fullname
      t.string :release_id
      t.string :author
      t.string :name
      t.datetime :created_at_ext
      t.datetime :published_at_ext
      t.integer :assets_count
      t.integer :body_length
      t.integer :reactions_count
      t.timestamps
    end
  end
end
