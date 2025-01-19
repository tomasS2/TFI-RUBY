class AddColourToProducts < ActiveRecord::Migration[8.0]
  def change
    add_reference :products, :colour, null: true, foreign_key: true
  end
end
