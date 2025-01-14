class AddParentIdToCategory < ActiveRecord::Migration[8.0]
  def change
    add_column :categories, :parent_id, :integer, default: nil
    add_index :categories, :parent_id
  end
end
