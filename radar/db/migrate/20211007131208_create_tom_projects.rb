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
