class CreateColours < ActiveRecord::Migration[8.0]
  def change
    create_table :colours do |t|
      t.string :name

      t.timestamps
    end
  end
end
