class CreateCapas < ActiveRecord::Migration[6.1]
  def change
    create_table :capas do |t|
      t.string :title
      t.text :description
      t.integer :pattern_id

      t.timestamps
    end
  end
end
