class AddEmailAndPhoneToSales < ActiveRecord::Migration[8.0]
  def change
    add_column :sales, :client_email, :string, null: false
    add_column :sales, :client_phone, :string
  end
end
