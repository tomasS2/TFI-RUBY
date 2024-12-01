class Product < ApplicationRecord
  has_many_attached :images
  has_many :product_sizes
  has_many :sizes, through: :product_sizes
  belongs_to :category
end
