class DeleteColumnHasSizeFromProduct < ActiveRecord::Migration[8.0]
  def change
    remove_column :products, :has_size
  end
end
