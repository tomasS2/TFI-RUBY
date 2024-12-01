class CreateSizes < ActiveRecord::Migration[8.0]
  def change
    create_table :sizes do |t|
      t.string :size_value
      
      t.timestamps
    end
  end
end
