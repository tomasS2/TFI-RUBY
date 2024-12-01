class CreateProductsSizes < ActiveRecord::Migration[8.0]
  def change
    create_join_table :products, :sizes do |t|
      t.index [:product_id, :size_id]
      t.index [:size_id, :product_id]
      t.integer :product_size_stock
    end
  end
end
