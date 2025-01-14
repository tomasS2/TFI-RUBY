class ApplicationController < ActionController::Base
  before_action :set_current_user, :set_primary_categories
  before_action :configure_permitted_parameters, if: :devise_controller?

  def set_current_user
    return unless session[:user_id]
    @current_user ||= User.find(session[:user_id])
  end

  def set_primary_categories
    @primary_categories = Category.where(parent_id: nil)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :phone_number, :role])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :phone_number, :role])
  end

  allow_browser versions: :modern
end
