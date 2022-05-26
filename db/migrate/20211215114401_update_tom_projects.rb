class UpdateTomProjects < ActiveRecord::Migration[6.1]
  def change
    add_column :tom_projects, :repo_fullname, :string
    add_column :tom_projects, :repo_url, :string
    add_column :tom_projects, :repoid, :string
    add_column :tom_projects, :invitation_id, :string
    add_column :tom_projects, :inviter_login, :string
    add_column :tom_projects, :permissions, :string
    add_column :tom_projects, :is_private, :string
    add_column :tom_projects, :owner_login, :string
    add_column :tom_settings, :invitations_endpoint, :string
    add_column :tom_settings, :invitations_accept_endpoint, :string
    add_column :tom_settings, :notifications_endpoint, :string
    add_column :tom_settings, :content_type, :string
  end
end
