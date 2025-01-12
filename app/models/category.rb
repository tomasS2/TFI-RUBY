class Category < ApplicationRecord
    has_many :product
    validates :category_name, presence: true

end
