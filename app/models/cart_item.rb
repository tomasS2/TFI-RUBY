class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product
  belongs_to :size, optional: true
end
