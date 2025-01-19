class Colour < ApplicationRecord
    has_many :product
    validates :name, presence: true
    validates :name, uniqueness: { message: "Este color ya se encuentra registrado en el sistema." }
end