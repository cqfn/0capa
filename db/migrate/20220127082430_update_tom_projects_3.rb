# frozen_string_literal: true

class UpdateTomProjects3 < ActiveRecord::Migration[6.1]
  def change
    add_column :tom_projects, :last_analysis_time_elapsed, :string
    rename_column :tom_settings, :starts_info_url, :stars_info_url
  end
end
