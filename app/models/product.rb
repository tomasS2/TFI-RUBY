class Product < ApplicationRecord
  has_many_attached :images
  has_many :products_sizes
  has_many :sizes, through: :products_sizes
  belongs_to :category

  validates :images, presence: true, on: :create
  validates :name, presence: true
  validates :price, presence: true

end
