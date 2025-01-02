class Product < ApplicationRecord
  has_many_attached :images
  has_many :product_sizes
  has_many :sizes, through: :product_sizes
  belongs_to :category

  validates :images, presence: true, on: :create
  validates :name, presence: true
  validates :price, presence: true
  validates :description, presence: true

end
