# frozen_string_literal: true

class UpdateActivationsTable < ActiveRecord::Migration[6.1]
  def change
    add_column :tom_radar_activations, :request_body, :json
  end
end
