class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, only: %i[ create edit update destroy ] 

  # GET /products or /products.json
  def index
    @products = Product.all
  end

  # GET /products/1 or /products/1.json
  def show
  end

  # GET /products/new
  def new
    if current_user && current_user.has_any_role?(:admin, :manager, :employee)
      @product = Product.new
      @categories = Category.all
    else
      redirect_to root_path
    end
  end

  # GET /products/1/edit

  def edit
    @categories = Category.all
    puts "aca si"
  end

  # POST /products or /products.json
  def create
    if current_user && current_user.has_any_role?(:admin, :manager, :employee)
      @product = Product.new(product_params.except(:product_sizes))
      @categories = Category.all
      @product.stock = -1 if product_params[:stock].blank? #para usar como flag

      respond_to do |format|
        if @product.save
          if product_params[:stock].blank?
            stock_sizes(product_params, params, @product.id)
          end
          format.html { redirect_to @product, notice: "El producto fue creado" }
          format.json { render :show, status: :created, location: @product }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @product.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_path
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    @categories = Category.all
    puts "tamo?"
    @product.stock = -1 if product_params[:stock].blank? #para usar como flag
    respond_to do |format|
      if params[:product][:images] == [""]
        puts params
        params[:product].delete(:images)
        puts params
      end
      puts "afuera"

      if @product.update(product_params)
        puts "ENTRE"
        puts product_params[:stock].blank?

        if product_params[:stock].blank?
          stock_sizes(product_params, params, @product.id)
        end
        format.html { redirect_to @product, notice: "El producto se actualizó correctamente" }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    if current_user && current_user.has_any_role?(:admin, :manager, :employee)
      @product.destroy!

      respond_to do |format|
        format.html { redirect_to products_path, status: :see_other, notice: "Product was successfully destroyed." }
        format.json { head :no_content }
      end
    else  
      redirect_to root_path
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.expect(product: [ :name, :description, :price, :stock, :colour, :category_id, images: [], product_sizes: [:size_id, :product_size_stock ] ])
    end

    def stock_sizes(parametros_producto, parametros_globales, id_producto)
      puts "lala"
      puts parametros_producto
      puts "lolo"
      puts parametros_globales

      if parametros_globales[:product][:product_sizes]
        parametros_globales[:product][:product_sizes].each do |size_data|
          next if size_data[:product_size_stock].blank?
          ProductSize.create!(
            product_id: id_producto,
            size_id: size_data[:size_id],
            product_size_stock: size_data[:product_size_stock],
          )
        end
      end
    end
end
