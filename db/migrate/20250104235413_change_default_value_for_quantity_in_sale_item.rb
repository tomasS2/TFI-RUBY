class ChangeDefaultValueForQuantityInSaleItem < ActiveRecord::Migration[8.0]
  def change
    change_column_default :sale_items, :quantity, 0

  end
end
