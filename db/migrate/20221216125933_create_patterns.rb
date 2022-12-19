class CreatePatterns < ActiveRecord::Migration[6.1]
  def change
    create_table :patterns do |t|
      t.string :title
      t.text :body
      t.integer :window
      t.float :threshold
      t.float :consensus_pattern, array: true, default: []

      t.timestamps
    end
  end
end
