class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.string :description, null: false
      t.decimal :price, null: false
      t.integer :stock, null: false
      t.string :colour
      t.references :category, null: false, foreign_key: true
      t.datetime :delete_date

      t.timestamps
    end
  end
end
