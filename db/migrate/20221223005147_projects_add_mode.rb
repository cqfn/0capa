# frozen_string_literal: true

class ProjectsAddMode < ActiveRecord::Migration[6.1]
  def change
    add_column :tom_projects, :mode, :varchar, default: 'Random'
  end
end
