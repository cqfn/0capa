# frozen_string_literal: true

class AddingArchivedFlag < ActiveRecord::Migration[6.1]
  def change
    add_column :tom_projects, :is_archived, :string
  end
end
