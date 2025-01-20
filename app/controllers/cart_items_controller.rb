class CartItemsController < ApplicationController
    before_action :set_cart_item, only: %i[ destroy ]
    before_action :authenticate_user! 

    
    def destroy
        @cart_item.destroy!
        respond_to do |format|
            format.html { redirect_to cart_path, status: :see_other, notice: "Se eliminó el producto del carrito correctamente" }
            format.json { head :no_content }
        end
    end

    private 
    def set_cart_item
        @cart_item = CartItem.find(params.expect(:id))
    end
  
end