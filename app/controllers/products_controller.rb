class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, only: %i[ create edit update destroy ] 

  # GET /products or /products.json
  def index
    @products = Product.all
  end


  def index_administration
    @products = Product.all
  end

  # GET /products/1 or /products/1.json
  def show
    @product = Product.find(params[:id])

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
  end

  # POST /products or /products.json
  def create
    if current_user && current_user.has_any_role?(:admin, :manager, :employee)
      @product = Product.new(product_params.except(:product_sizes))
      @categories = Category.all
      #@product.has_size = product_params[:stock].blank? ? true : false

      respond_to do |format|
        if @product.save
          if product_params[:stock].blank?
            stock_sizes(params[:product][:product_sizes], @product.id)
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
    #@product.has_size = product_params[:stock].blank? ? true : false
    respond_to do |format|
      if params[:product][:images] == [""]
        params[:product].delete(:images)
      end

      if @product.update(product_params)

        if product_params[:stock].blank?
          stock_sizes(params[:product][:product_sizes_attributes], @product.id)
        else  
          if @product.product_sizes
            ProductSize.where(product_id: @product.id).delete_all
          end
        end

        format.html { redirect_to @product, notice: "El producto se actualizó correctamente" }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end


    
  def soft_delete
    @product = Product.find(params[:id])
    puts "aca"
    @product.delete_date = DateTime.now
    if @product.save
      if @product.product_sizes.any?
        ProductSize.stock_a_cero(@product.id)
      else
        @product.update_column(:stock, 0)
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

  def show_stock
    @product = Product.find(params[:id])
  end

  def modify_stock
    @product = Product.find(params[:id])
    
    if @product.product_sizes.any?
      #itero sobre los distintos talles con stock
      params[:product][:product_sizes_attributes].each do |size_data|
        
        product_size_edit = ProductSize.find_by(product_id: @product.id, size_id: size_data[:size_id])

        #comparo el stock del talle quetengo guardado con el ingresado por parametro paraver si es nacesario actualizar
        if product_size_edit.product_size_stock != size_data[:product_size_stock].to_i
          product_size_edit.product_size_stock = size_data[:product_size_stock].to_i
          ProductSize.update_stock(@product.id, size_data[:size_id], size_data[:product_size_stock].to_i)
        end
      end
    else
      #caso en el que el producto no tiene talles (se maneja con stock global
      new_stock = params[:product][:stock].blank? ? 0 : params[:product][:stock].to_i
      if @product.stock != new_stock
        @product.update_column(:stock, new_stock)
      end
    end
  
    redirect_to index_administration_products_path, notice: 'El stock se actualizó correctamente.'
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

    def stock_sizes(product_sizes, id_producto)
      if product_sizes
        product_sizes.each do |size_data|
          next if size_data[:product_size_stock].blank?
          if ProductSize.exists?(size_id: size_data[:size_id], product_id: id_producto)
            product_size_edit = ProductSize.find_by(product_id: id_producto, size_id: size_data[:size_id])
            if product_size_edit.product_size_stock != size_data[:product_size_stock].to_i
              ProductSize.where(product_id: id_producto, size_id: size_data[:size_id]).update_all(product_size_stock: size_data[:product_size_stock].to_i)
            end
          else
            ProductSize.create!(
              product_id: id_producto,
              size_id: size_data[:size_id],
              product_size_stock: size_data[:product_size_stock],
            )
          end
        end
      end
    end
end
