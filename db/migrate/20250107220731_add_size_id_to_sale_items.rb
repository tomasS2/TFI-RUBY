class AddSizeIdToSaleItems < ActiveRecord::Migration[8.0]
  def change
    add_reference :sale_items, :size, foreign_key: true, null: true

  end
end
