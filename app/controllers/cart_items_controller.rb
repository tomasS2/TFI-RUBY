class CartItemsController < ApplicationController
    before_action :set_cart_item, only: %i[ destroy ]

    
    def destroy
        @cart_item.destroy!
        respond_to do |format|
            format.html { redirect_to cart_path, status: :see_other, notice: "Se eliminó el producto del carrito correctamente" }
            format.json { head :no_content }
        end
    end

    def update
        @cart_item = CartItem.find(params[:id])
        new_quantity = params[:quantity].to_i
        if @cart_item.product.has_stock(new_quantity, @cart_item.size_id)
            if current_user
                current_user.cart.save_cart_item(@cart_item.product, new_quantity, @cart_item.size_id)
            else
                cart = Cart.find(session[:cart])
                cart.save_cart_item(@cart_item.product, new_quantity, @cart_item.size_id)
            end
            redirect_to cart_path, notice: "Cantidad actualizada correctamente."
        else
            redirect_to cart_path, alert: "No se pudo actualizar la cantidad"
        end
    end

    private 
    def set_cart_item
        @cart_item = CartItem.find(params.expect(:id))
    end
  
end