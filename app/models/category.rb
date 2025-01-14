class Category < ApplicationRecord
    has_many :product
    validates :category_name, presence: true
    validates :category_name, uniqueness: { message: "El nombre de la categoría no puede repetirse. Elige otro." }
    validates :parent_id, presence: { message: "Debe elegir una categoría principal."}
    belongs_to :parent, class_name: 'Category', optional: true
    has_many :subcategories, class_name: 'Category', foreign_key: 'parent_id'

end
