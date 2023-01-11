# frozen_string_literal: true

class FixPatterns < ActiveRecord::Migration[6.1]
  def change
    remove_column :patterns, :title, :varchar
    remove_column :patterns, :body, :text
    add_column :patterns, :metrics, :varchar
  end
end
