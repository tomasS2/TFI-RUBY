class ChangeStockToAllowNull < ActiveRecord::Migration[8.0]
  def change
    change_column_null :products, :stock, true

  end
end
