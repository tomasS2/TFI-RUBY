class Sale < ApplicationRecord
  belongs_to :user 
  has_many :sale_items, dependent: :destroy
  has_many :products, through: :sale_items 
end
