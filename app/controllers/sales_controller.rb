class SalesController < ApplicationController
  before_action :set_sale, only: %i[ show edit update destroy show_products cancel]
  before_action :set_cart, only: %i[ create ]
  before_action :authenticate_user!, only: %i[ new edit update destroy index ] 

  # GET /sales or /sales.json
  def index
    @sales = Sale.all
  end

  # GET /sales/1 or /sales/1.json
  def show
  end

  # GET /sales/new
  def new
    @sale = Sale.new
  end

  # GET /sales/1/edit
  def edit
  end

  # POST /sales or /sales.json
  def create
    unless valid_card_number?(params[:client_card])
      flash[:alert] = "Debe ingresar un número de tarjeta con 16 dígitos"
      redirect_to cart_path and return
    end
    response = Sale.create_sale(@cart, params[:client], params[:client_email], params[:client_phone].presence || nil)
    if response[:success]
      if current_user
        flash[:notice] = "Venta realizada existosamente"
        redirect_to sales_path
      else
        flash[:notice] = "Compra realizada existosamente"
        redirect_to root_path
      end
    else
      flash[:alert] = response[:message] 
      redirect_to cart_path
    end
  end

  # PATCH/PUT /sales/1 or /sales/1.json
  def update
    respond_to do |format|
      if @sale.update(sale_params)
        format.html { redirect_to @sale, notice: "Sale was successfully updated." }
        format.json { render :show, status: :ok, location: @sale }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @sale.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sales/1 or /sales/1.json
  def destroy
    @sale.destroy!

    respond_to do |format|
      format.html { redirect_to sales_path, status: :see_other, notice: "Sale was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def show_products
  end
  
  def cancel
    @sale.cancel_sale()
    flash[:notice] = "Venta #{@sale.id} cancelada"
    redirect_to sales_path
  end


  private
    # Use callbacks to share common setup or constraints between actions.
  def set_sale
    @sale = Sale.find(params.expect(:id))
  end

  def set_cart
    if current_user
      @cart = current_user.cart
    else
      @cart = Cart.find(session[:cart])
    end
  end

  # Only allow a list of trusted parameters through.
  def sale_params
    params.fetch(:sale, {})
  end

  def valid_card_number?(numero_tarjeta)
    numero_tarjeta.present? && numero_tarjeta =~ /\A\d{16}\z/
  end

end
