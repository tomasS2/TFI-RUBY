class UsersController < ApplicationController
    before_action :set_user, only: %i[ show edit update destroy ]
    helper_method :user_roles
    before_action :authenticate_user! 


    def index  
      @users = User.all
    end
    
    def new  
      @user = User.new
    end

    def show
    end
    
    
    def edit
    end

    def create
        @user = User.new(user_params)
        respond_to do |format|
          if @user.save
            format.html { redirect_to @user, notice: "El usuario fue creado satisfactoriamente." }
            format.json { render :show, status: :created, location: @user }
          else
            format.html { render :new, status: :unprocessable_entity }
            format.json { render json: @user.errors, status: :unprocessable_entity }
          end
        end
      end
    

    def update

      if @user.has_any_role?(:admin, :manager, :employee)
        @user.roles.each do |role|
          params[:user][:role].delete(role.name)
        end
      end
      agrego_rol = params[:user][:role].length > 0
      es_el_mismo = @user == current_user
      if user_params[:password].present?
        if @user.update(user_params)
          redirecciones_update(es_el_mismo)
          if agrego_rol
            params[:user][:role].each do |role|
              @user.add_role(role) if %w[admin manager employee].include?(role)
            end
          end
        else
          redirecciones_update_error_validacion()
        end
      else
        if @user.update(user_params.except(:password))
          redirecciones_update(es_el_mismo)
          if agrego_rol
            params[:user][:role].each do |role|
              @user.add_role(role) if %w[admin manager employee].include?(role)
            end
          end
        else
          redirecciones_update_error_validacion()
        end
      end        
    end


    def destroy
      @user.destroy!
      respond_to do |format|
        format.html { redirect_to users_path, status: :see_other, notice: "User was successfully destroyed." }
        format.json { head :no_content }
      end
    end

    def deactivate
      user = User.find(params[:id]) 
      if current_user != user && current_user.has_role?(:admin) && user.status == 'active' 
        user.update_column(:status, 'inactive')
        new_password = SecureRandom.hex(10)
        user.password = new_password
        user.save
        redirect_to app_users_path, notice: 'El usuario ha sido desactivado correctamente.'
      end
    end

    def activate
      @user = User.find(params[:id])
      if current_user != @user && current_user.has_role?(:admin) && @user.status != 'active' 
        @user.password = params[:user][:password]
        if @user.valid?(:update_password) 
          @user.update_column(:status, 'active')
          @user.save
          redirect_to app_users_path, notice: 'El usuario ha sido activado correctamente.' and return
        else
          render :update_password_activate_app_user
        end
      else
        flash[:alert] = 'Error al asignar la nueva contraseña'
        render :update_password_activate_app_user
      end
    end

    def update_password_activate
      @user = User.find(params[:id])
      if !(current_user != @user && current_user.has_role?(:admin) && @user.status != 'active')
        redirect_to app_users_path, alert: 'Este usuario ya está activo.'
      else  
        render :update_password_activate_app_user
      end
    end


    private
      def set_user
        @user = User.find(params.expect(:id))
      end

      def user_params
        params.expect(user: [ :name, :username, :email, :phone_number, :password ])
      end

      def user_roles(user)
        return user.roles.pluck(:name).join(", ")
      end

      def redirecciones_update(es_el_mismo)
        respond_to do |format|
          if !es_el_mismo
            format.html { redirect_to app_users_path, notice: "El usuario fue actualizado correctamente." }
          else  
            format.html { redirect_to new_user_session_path, notice: "El usuario fue actualizado correctamente. Vuelve a iniciar sesión." }
          end
          format.json { render :show, status: :ok, location: @user }
        end
      end

      def redirecciones_update_error_validacion()
        respond_to do |format|

          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
end
