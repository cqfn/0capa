class AddWebhookActiveToTomProjects < ActiveRecord::Migration[6.1]
  def change
    add_column :tom_projects, :webhook_active, :string, :default => 'N'
  end
end
