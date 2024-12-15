class DropRole < ActiveRecord::Migration[8.0]
  def change
    drop_table :roles

  end
end
