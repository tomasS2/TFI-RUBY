class ProductSize < ApplicationRecord
  self.table_name = 'products_sizes'
  belongs_to :product
  belongs_to :size
  validates :product_size_stock, numericality: { greater_than_or_equal_to: 0 }


  def self.update_stock(product_id, size_id, new_stock)
    where(product_id: product_id, size_id: size_id).update_all(product_size_stock: new_stock)
  end

end
