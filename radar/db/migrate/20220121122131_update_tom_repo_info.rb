class UpdateTomRepoInfo < ActiveRecord::Migration[6.1]
  def change
    add_column :tom_projects, :repo_created_at, :datetime
  end
end
