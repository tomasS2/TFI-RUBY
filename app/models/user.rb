class User < ApplicationRecord
  rolify
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable 

  validates :username, :phone_number, presence: { message: "Todos los campos deben estar completos"}
  validates :username, uniqueness: { message: "Este nombre de usuario ya está registrado"}
  #fijarse que también se le asigne un rol
end
