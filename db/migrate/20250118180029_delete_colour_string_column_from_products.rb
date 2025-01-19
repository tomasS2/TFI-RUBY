class DeleteColourStringColumnFromProducts < ActiveRecord::Migration[8.0]
  def change
    remove_column :products, :colour

  end
end
