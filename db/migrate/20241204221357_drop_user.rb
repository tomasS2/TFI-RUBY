class DropUser < ActiveRecord::Migration[8.0]
  def change
    drop_table :users
    drop_table :users_roles
  end
end