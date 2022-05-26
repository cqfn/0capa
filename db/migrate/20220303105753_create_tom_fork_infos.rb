class CreateTomForkInfos < ActiveRecord::Migration[6.1]
  def change
    create_table :tom_fork_infos do |t|
      t.string :repoid
      t.string :repo_fullname
      t.string :folk_id
      t.string :folk_fullname
      t.string :owner
      t.string :is_private
      t.datetime :created_at_ext
      t.datetime :updated_at_ext
      t.datetime :pushed_at_ext

      t.timestamps
    end
  end
end
