# frozen_string_literal: true

class UpdateTomMetrics < ActiveRecord::Migration[6.1]
  def change
    add_column :tom_pull_infos, :commits_counts, :integer
    add_column :tom_pull_infos, :is_locked, :string
    add_column :tom_pull_infos, :code_blocks_counter, :integer
    add_column :tom_pull_infos, :links_counter, :string
  end
end
