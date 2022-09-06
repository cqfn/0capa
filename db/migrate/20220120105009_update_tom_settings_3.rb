# frozen_string_literal: true

class UpdateTomSettings3 < ActiveRecord::Migration[6.1]
  def change
    add_column :tom_settings, :commits_info_url, :string
    add_column :tom_settings, :contributors_info_url, :string
    add_column :tom_settings, :forks_info_url, :string
    add_column :tom_settings, :issues_info_url, :string
    add_column :tom_settings, :pulls_info_url, :string
    add_column :tom_settings, :releases_info_url, :string
    add_column :tom_settings, :starts_info_url, :string
    add_column :tom_settings, :workflows_info_url, :string
  end
end
