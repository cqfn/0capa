class FixGeneratedCapasRepoInfo < ActiveRecord::Migration[6.1]
  def change
    add_column :generated_capas, :repo_name, :varchar
  end
end
