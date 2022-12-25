class FixCapas < ActiveRecord::Migration[6.1]
  def change
    add_column :patterns, :title, :varchar
  end
end
