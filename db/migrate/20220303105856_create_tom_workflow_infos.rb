# frozen_string_literal: true

class CreateTomWorkflowInfos < ActiveRecord::Migration[6.1]
  def change
    create_table :tom_workflow_infos do |t|
      t.string :repoid
      t.string :repo_fullname
      t.string :action_id
      t.string :name
      t.string :action_number
      t.string :event
      t.string :status
      t.string :conclusion
      t.string :workflow_id
      t.integer :run_attempt_count
      t.datetime :created_at_ext
      t.datetime :updated_at_ext
      t.datetime :started_at_ext
      t.string :actor
      t.timestamps
    end
  end
end
