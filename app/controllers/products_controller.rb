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
      @product.has_size = product_params[:stock].blank? ? true : false

      respond_to do |format|
        if @product.save
          if @product.has_size
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
    @product.has_size = product_params[:stock].blank? ? true : false
    respond_to do |format|
      if params[:product][:images] == [""]
        params[:product].delete(:images)
      end

      if @product.update(product_params)

        if @product.has_size
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
    
    ##hacer validaciones en el modelo por si no ingresa ningun valor
    # Verificar si el producto tiene tamaños
    if @product.has_size
      # Iterar sobre cada tamaño del producto
      params[:product][:product_sizes_attributes].each do |size_data|
        product_size_edit = ProductSize.find_by(product_id: @product.id, size_id: size_data[:size_id])
        puts "que sera 2"
        puts size_data
        puts product_size_edit
        #puts product_size_edit.product_size_stock 
        #puts size_data[:product][:product_sizes_attributes][:product_size_stock].to_i 
        #puts product_size_edit.product_size_stock != size_data[:product][:product_sizes_attributes][:product_size_stock].to_i 
        # Verificar si el stock ha cambiado
        if product_size_edit.product_size_stock != size_data[:product_size_stock].to_i
          product_size_edit.product_size_stock = size_data[:product_size_stock].to_i
          puts "aca?"
          # Validar el cambio antes de guardarlo
          unless product_size_edit.valid?
            # Si no es válido, devolver a la vista de edición con el mensaje de error
            render :show_stock_path, alert: "Hubo un error al actualizar el stock del tamaño #{size_data[:size_id]}."
            return
          end
  
          # Guardar el cambio si es válido
          puts "estoy"

          ProductSize.where(product_id: @product.id, size_id: size_data[:size_id]).update_all(product_size_stock: size_data[:product_size_stock].to_i)
          puts "llegue"
        end
      end
    else
      # Si no tiene tamaños, actualizar el stock del producto
      @product.stock = params[:stock]
  
      # Validar si el stock es válido
      unless @product.valid?
        # Si no es válido, devolver a la vista de edición con el mensaje de error
        render :edit, alert: 'Hubo un error al actualizar el stock. Verifique el campo de stock.'
        return
      end
  
      # Guardar el cambio si es válido
      @product.save!
    end
  
    # Si todo salió bien, redirigir con un mensaje de éxito
    redirect_to index_administration_products_path, notice: 'El stock se actualizó correctamente.'
  
  rescue StandardError => e
    # Manejar cualquier otro error inesperado y registrar el error
    logger.error "Error al modificar el stock del producto #{@product.id}: #{e.message}"
    redirect_to edit_product_path(@product), alert: 'Ocurrió un error al intentar actualizar el stock.'
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
