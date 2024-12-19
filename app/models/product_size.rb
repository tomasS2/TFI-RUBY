class ProductSize < ApplicationRecord
  self.table_name = 'products_sizes'
  belongs_to :product
  belongs_to :size
  validates :product_size_stock, numericality: { greater_than_or_equal_to: 0 }
end
