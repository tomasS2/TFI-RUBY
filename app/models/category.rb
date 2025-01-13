class Category < ApplicationRecord
    has_many :product
    validates :category_name, presence: true
    validates :category_name, uniqueness: { message: "El nombre de la categoría no puede repetirse. Elige otro." }

end
