# frozen_string_literal: true

class CreateGeneratedCapas < ActiveRecord::Migration[6.1]
  def change
    create_table :generated_capas do |t|
      t.string :title
      t.text :body
      t.string :status
      t.string :mode, default: 'random'
      t.timestamps
    end
  end
end
