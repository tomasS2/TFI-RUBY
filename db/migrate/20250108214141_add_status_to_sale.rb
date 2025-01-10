class AddStatusToSale < ActiveRecord::Migration[8.0]
  def change
    add_column :sales, :status, :string, default: 'done'
  end
end
