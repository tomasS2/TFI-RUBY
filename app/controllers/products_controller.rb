class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy soft_delete show_stock modify_stock ]
  before_action :authenticate_user!, only: %i[ create edit update destroy index_administration ] 

  # GET /products or /products.json
  def index
    @products = Product.where(delete_date: nil)  
  end


  def index_administration
    @products = Product.where(delete_date: nil) 
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
            @product.update_or_create_product_sizes(params[:product][:product_sizes])
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
          @product.update_or_create_product_sizes(params[:product][:product_sizes_attributes])
        else  
          if @product.product_sizes
            @product.delete_product_sizes()
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
    @product.delete_date = DateTime.now
    if @product.save
      if @product.product_sizes.any?
        ProductSize.stock_a_cero(@product.id)
      else
        @product.update_column(:stock, 0)
      end
      redirect_to index_administration_products_path, notice: "El producto fue eliminado correctamente"
    else
      redirect_to index_administration_products_path, alert: "Hubo un error al intentar eliminar el producto"
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
  end

  def modify_stock
    
    if @product.product_sizes.any?
      @product.modify_size_stock(params[:product][:product_sizes_attributes])
    else
      @product.modify_global_stock(params[:product][:stock].blank? ? 0 : params[:product][:stock].to_i)
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

end
