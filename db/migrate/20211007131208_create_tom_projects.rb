# frozen_string_literal: true

# Creating TOM Project table to store project's information retrival settings
class CreateTomProjects < ActiveRecord::Migration[6.1]
  def change
    create_table :tom_projects do |t|
      t.string :name
      t.string :description
      t.string :isactive

      t.timestamps
    end
  end
end
