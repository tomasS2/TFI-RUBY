class UsersController < ApplicationController
    before_action :set_user, only: %i[ show edit update destroy ]
    
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
      respond_to do |format|
        if @user.update(user_params)
          format.html { redirect_to @user, notice: "El usuario fue creado satisfactoriamente." }
          format.json { render :show, status: :ok, location: @user }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
  

    #####VER SI HAY Q SACARLO (o modificarlo)
    def destroy
      @user.destroy!

      respond_to do |format|
        format.html { redirect_to users_path, status: :see_other, notice: "User was successfully destroyed." }
        format.json { head :no_content }
      end
    end


    private
      def set_user
          @user = User.find(params.expect(:id))
      end

      def user_params
        params.expect(user: [ :name, :username, :email, :phone_number, :password ])
      end
end
