class Cart < ApplicationRecord
  belongs_to :user, optional: true
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items 

  def save_cart_item (product, quantity, size_id)     
    cart_item = self.cart_items.find_or_initialize_by(product: product, size_id: size_id)
    cart_item.quantity += quantity
    cart_item.price = cart_item.quantity * product.price
    cart_item.save
  end

  def total_price()
    self.cart_items.sum { |cart_item| cart_item.price }
  end


  def self.find_or_create_from_session(session)
    if session[:cart].present?
      Cart.find(session[:cart])
    else
      create_new_cart_for_session(session)
    end
    rescue ActiveRecord::RecordNotFound, NoMethodError
      create_new_cart_for_session(session)
  end

  private

  def self.create_new_cart_for_session(session)
    cart = Cart.create
    session[:cart] = cart.id
    cart
  end

end
