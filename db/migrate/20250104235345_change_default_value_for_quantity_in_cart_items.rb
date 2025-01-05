class ChangeDefaultValueForQuantityInCartItems < ActiveRecord::Migration[8.0]
  def change
    change_column_default :cart_items, :quantity, 0

  end
end
