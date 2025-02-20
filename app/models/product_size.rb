class ProductSize < ApplicationRecord
  self.table_name = 'products_sizes'
  belongs_to :product
  belongs_to :size
  validates :product_size_stock, numericality: { greater_than_or_equal_to: 0, message: "debe ser un número mayor o igual a 0" }


  def self.update_stock(product_id, size_id, quantity)
    where(product_id: product_id, size_id: size_id).update_all(product_size_stock: quantity)
  end

  def self.stock_a_cero(product_id)
    where(product_id: product_id).update_all(product_size_stock: 0)
  end

end
