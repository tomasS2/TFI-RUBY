class MakeUserIdOptionalInSales < ActiveRecord::Migration[8.0]
  def change
    change_column_null :sales, :user_id, true

  end
end
