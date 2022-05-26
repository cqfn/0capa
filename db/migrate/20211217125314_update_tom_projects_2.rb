class UpdateTomProjects2 < ActiveRecord::Migration[6.1]
  def change
    add_column :tom_settings, :repos_info_url, :string
    add_column :tom_projects, :last_commit_id, :string
    add_column :tom_projects, :last_scanner_date, :datetime
    add_column :tom_projects, :source, :string
  end
end
