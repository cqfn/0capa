# frozen_string_literal: true

class UpdatePushInfo < ActiveRecord::Migration[6.1]
  def change
    add_column :tom_push_infos, :repo_name, :string
    add_column :tom_push_infos, :repo_url, :string
    add_column :tom_push_infos, :status, :string, default: 'P'
    rename_column :tom_push_infos, :repoid, :head_commit_id
  end
end
