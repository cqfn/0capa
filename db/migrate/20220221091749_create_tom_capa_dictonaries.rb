# frozen_string_literal: true

class CreateTomCapaDictonaries < ActiveRecord::Migration[6.1]
  def change
    create_table :tom_capa_dictonaries do |t|
      t.string :case_id
      t.string :description
      t.string :category
      t.timestamps
    end
  end
end
