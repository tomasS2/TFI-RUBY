class CreateSales < ActiveRecord::Migration[8.0]
  def change
    create_table :sales do |t|
      t.decimal :total, null: false
      t.references :user, null: false, foreign_key: true
      t.string :client, null: false
      t.timestamps
    end
  end
end
