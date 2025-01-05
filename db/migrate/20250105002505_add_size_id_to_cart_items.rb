class AddSizeIdToCartItems < ActiveRecord::Migration[8.0]
  def change
    add_reference :cart_items, :size, foreign_key: true, null: true
  end
end
