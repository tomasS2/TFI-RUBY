class Size < ApplicationRecord
  has_many :products_sizes
  has_many :products, through: :products_sizes
  validates :size_value, presence: true
  validates :size_value, uniqueness: { message: "El valor del talle no puede repetirse. Elige otro." }
end
