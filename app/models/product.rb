class Product < ApplicationRecord
  has_many_attached :images
  has_many :product_sizes
  has_many :sizes, through: :product_sizes
  belongs_to :category

  validates :images, presence: true, on: :create
  validates :name, presence: true
  validates :price, presence: true
  validates :price, numericality: {greater_than_or_equal_to: 0}
  validates :description, presence: true
  validates :stock, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

end
