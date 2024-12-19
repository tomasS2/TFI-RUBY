class User < ApplicationRecord
  rolify
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable 

  validates :username, uniqueness: { message: "Este nombre de usuario ya está registrado"}
  validates :username, presence: true
  validates :phone_number, presence: true
  #fijarse que también se le asigne un rol
end
