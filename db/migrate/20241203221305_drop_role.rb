class DropRole < ActiveRecord::Migration[8.0]
  def change
    drop_table :roles
    drop_table :roles_users
  end
end
