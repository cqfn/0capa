# frozen_string_literal: true

class CreateTomAnalysisMetrics < ActiveRecord::Migration[6.1]
  def change
    create_table :tom_analysis_metrics do |t|
      t.string :analysis_id
      t.string :metric_name
      t.string :value
      t.string :is_best_value
      t.timestamps
    end
  end
end
