# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController

  #permite que los usuarios autenticados accedan a las páginas de registro (xq ellos crean a los otros usuarios)
  skip_before_action :require_no_authentication, only: [:new, :create]


  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  #verifica si el usuario cuenta con los roles para crear otro usuario (debe tener admin o manager)
  before_action :authorize_role_assignment, only: [:new, :create]


  def new
    if current_user
      super
    else
      redirect_to root_path, alert: 'No cuentas con el rol para poder registrar usuarios.'
    end
  end

  def create
    build_resource(sign_up_params.except(:role))
    if resource.save
      assign_role(resource)
      flash[:notice] = 'Se ha creado el usuario.'
      redirect_to app_users_path and return
    else
      render :new
    end
  end
  
  protected

    def assign_role(user)
      if !params[:user][:role].blank?
        if current_user.has_role?(:admin)
          params[:user][:role].each do |role|
            user.add_role(role) if %w[admin manager employee].include?(role)
          end
        elsif current_user.has_role?(:manager)
          params[:user][:role].each do |role|
            user.add_role(role) if %w[manager employee].include?(role)
          end
        end
      end
    end

    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :phone_number, :role])
    end
    
    def configure_account_update_params
      devise_parameter_sanitizer.permit(:account_update, keys: [:username, :phone_number, :role])
    end
    
    def authorize_role_assignment
      unless !current_user || current_user.has_role?(:admin) || current_user.has_role?(:manager)
        redirect_to root_path, alert: 'No cuentas con el rol para poder crear usuarios'
      end
    end

end
