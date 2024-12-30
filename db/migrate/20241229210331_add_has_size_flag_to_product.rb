class AddHasSizeFlagToProduct < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :has_size, :boolean, default: true

  end
end
