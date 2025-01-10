class Sale < ApplicationRecord
  belongs_to :user 
  has_many :sale_items, dependent: :destroy
  has_many :products, through: :sale_items 
  validates :client, presence: true
  validates :client, format: { with: /\A[a-zA-Z\s]+\z/, message: "El nombre solo puede contener letras y espacios" }, if: -> { client.present? }



  def total_price()
    self.sale_items.sum { |sale_item| sale_item.price }
  end

  def cancel_sale()
    self.sale_items.each do |item|
      if item.size_id.nil?
        item.product.update_stock_global(item.product.stock + item.quantity)
      else
        product_size_stock_selected = ProductSize.find_by(product_id: item.product_id, size_id: item.size_id).product_size_stock
        ProductSize.update_stock(item.product_id, item.size_id, product_size_stock_selected + item.quantity)
      end
    end
    self.update_column(:status, 'canceled')
  end
  
  def self.create_sale(cart, client)
    sale = Sale.new(user: cart.user, total: cart.total_price(), client: client)
    unless sale.valid?
      return { success: false, message: sale.errors.full_messages.join(", ") }
    end

    begin
      ActiveRecord::Base.transaction do
        sale.save!

        cart.cart_items.each do |cart_item|
          size_id = cart_item.size_id.nil? ? nil : cart_item.size_id
          unless cart_item.product.has_stock(cart_item.quantity, size_id)
            raise "No hay suficiente stock del producto #{cart_item.product.name}. No se pudo completar la venta."
          end
          sale.sale_items.create!(product: cart_item.product, quantity: cart_item.quantity, price: cart_item.price, size_id: size_id)
          if size_id.nil?
            cart_item.product.update_stock_global(cart_item.product.stock - cart_item.quantity)
          else
            cart_item.product.update_size_stock(cart_item.quantity, size_id)
          end
        end
  
        cart.cart_items.destroy_all
  
        return { success: true, sale: sale }
      end
    rescue => e
      return { success: false, message: e.message }
    end
  end
end
  