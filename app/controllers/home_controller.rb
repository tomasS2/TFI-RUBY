class HomeController < ApplicationController

    def index
        @new_products = Product.order(created_at: :desc).limit(3)
    end

end
