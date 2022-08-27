# frozen_string_literal: true

class UpdateTomProjects4 < ActiveRecord::Migration[6.1]
  def change
    add_column :tom_projects, :status, :string
    add_column :tom_projects, :node_name, :string
    add_column :tom_settings, :node_name, :string
  end
end
