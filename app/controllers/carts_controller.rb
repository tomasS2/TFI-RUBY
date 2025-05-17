class CartsController < ApplicationController
    before_action :set_cart, only: %i[ add_item show ]

    def add_item()
        product = Product.find(params[:product_id])
        if product.has_size_without_size_id_sent?(params[:size_id])
            redirect_to product_path(product), alert: 'Debe ingresar un talle'
        else
            quantity = params[:quantity].to_i
            size_id = params[:size_id].present? ? params[:size_id].to_i : nil
            if product.has_stock(quantity, size_id)
                @cart.save_cart_item(product, quantity, size_id)
                redirect_to cart_path, notice: 'Producto agregado al carrito.'
            else
                redirect_to product_path(product), alert: 'No se pudo agregar el producto al carrito porque no tiene suficiente stock.'
            end
        end
    end

    def clear_cart
        if current_user
            current_user.cart.cart_items.destroy_all
        else
            cart = Cart.find(session[:cart])
            cart.cart_items.destroy_all
        redirect_to cart_path, notice: "El carrito ha sido vaciado."
        end
    end

    def show() 
    end

    private 
    def set_cart
        if current_user
            @cart = current_user.cart || current_user.create_cart
        else
            @cart = Cart.find_or_create_from_session(session)
        end
    end
end