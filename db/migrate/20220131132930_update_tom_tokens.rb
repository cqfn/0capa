class UpdateTomTokens < ActiveRecord::Migration[6.1]
  def change
    add_column :tom_tokens_queues, :isactive, :string
    change_column_default :tom_tokens_queues, :isactive, "Y"
  end
end
