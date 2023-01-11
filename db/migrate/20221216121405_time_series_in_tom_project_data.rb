# frozen_string_literal: true

class TimeSeriesInTomProjectData < ActiveRecord::Migration[6.1]
  def change
    add_column :tom_projects, :total_analyse_state, :string, default: 'N'
    add_column :tom_projects, :last_commit_analyse_hash, :string, default: 'none'
  end
end
