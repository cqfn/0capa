class UpdateTomSettings < ActiveRecord::Migration[6.1]
  def change
    add_column :tom_settings, :issues_Comments_info_url, :string
  end
end
