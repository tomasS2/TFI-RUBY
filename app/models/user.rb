class User < ApplicationRecord
  rolify
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable 

  validates :username, uniqueness: { message: "Este nombre de usuario ya está registrado"}
  validates :username, presence: true
  validates :phone_number, presence: { message: "El campo de número de teléfono no puede estar vacío" }
  validates :phone_number, format: { with: /\A\+\d{1,4}\d{1,10}\z/, message: "El número de teléfono no cumple con el formato" }, unless: -> { phone_number.blank? }
  has_one :cart, dependent: :destroy

  def add_selected_roles(roles_from_form)
    if !roles_from_form.blank?
      roles_from_form.each do |role|
        self.add_role(role) if %w[admin manager employee].include?(role)
      end
    end
  end
  
  def delete_unselected_roles(roles_from_form)
    roles_actuales = self.roles

    if !roles_actuales.blank?
      if roles_from_form.blank?
        self.roles.each do |role|
          self.remove_role(role.name) 
        end
      else
        roles_actuales.each do |role|
          if !roles_from_form.include?(role.name)
            self.remove_role(role.name)
          end
        end
      end
    end
  end

  def deactivate_user()
    self.update_column(:status, 'inactive')
    self.password = SecureRandom.hex(10)
    self.save
  end

  def activate_user(new_password)
    self.password = new_password
    if self.valid?(:update_password) 
      self.update_column(:status, 'active')
      self.save
      return true
    else  
      return false
    end
  end



end
