class CreateTomAnalyses < ActiveRecord::Migration[6.1]
  def change
    create_table :tom_analyses do |t|
      t.string :extractor_id
      t.string :repo_name
      t.timestamps
    end
  end
end
