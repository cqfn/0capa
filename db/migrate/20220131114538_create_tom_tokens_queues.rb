# frozen_string_literal: true

class CreateTomTokensQueues < ActiveRecord::Migration[6.1]
  def change
    create_table :tom_tokens_queues do |t|
      t.string :token
      t.string :source
      t.string :owner
      t.timestamps
    end
  end
end
