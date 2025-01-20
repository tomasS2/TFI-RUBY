class Colour < ApplicationRecord
    has_many :product
    validates :name, presence: true
    validates :name, uniqueness: { message: "Este color ya se encuentra registrado en el sistema." }
    validates :name, format: { with: /\A[a-zA-Z\s]+\z/, message: "El nombre del color solo puede contener letras y espacios" }, if: -> { name.present? }

end