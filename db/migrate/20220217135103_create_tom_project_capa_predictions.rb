class CreateTomProjectCapaPredictions < ActiveRecord::Migration[6.1]
  def change
    create_table :tom_project_capa_predictions do |t|
      t.integer :analysis_id
      t.string :repo_fullname
      t.string :label
      t.string :status
      t.timestamps
    end
  end
end
