# frozen_string_literal: true

class UpdateTomSettings2 < ActiveRecord::Migration[6.1]
  def change
    add_column :tom_settings, :repos_diff_url, :string
  end
end
