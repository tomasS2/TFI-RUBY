class Product < ApplicationRecord
  has_many_attached :images
  has_many :product_sizes
  has_many :sizes, through: :product_sizes
  belongs_to :category

  validates :images, presence: true, on: :create
  validates :name, presence: true
  validates :price, presence: true
  validates :price, numericality: {greater_than_or_equal_to: 0}
  validates :description, presence: true
  validates :stock, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  def delete_product_sizes()
    ProductSize.where(product_id: self.id).delete_all
  end

  def update_or_create_product_sizes(product_sizes)
    return if product_sizes.blank?
    product_sizes.each do |size_data|
      if self.product_sizes.exists?(size_id: size_data[:size_id]) && size_data[:product_size_stock].blank?
        size_data[:product_size_stock] = 0
      end
      next if size_data[:product_size_stock].blank?
      if ProductSize.exists?(size_id: size_data[:size_id], product_id: self.id)
        product_size_edit = ProductSize.find_by(product_id: self.id, size_id: size_data[:size_id])
        if product_size_edit.product_size_stock != size_data[:product_size_stock].to_i
          ProductSize.where(product_id: self.id, size_id: size_data[:size_id]).update_all(product_size_stock: size_data[:product_size_stock].to_i)
        end
      else
        ProductSize.create!(
          product_id: self.id,
          size_id: size_data[:size_id],
          product_size_stock: size_data[:product_size_stock],
        )
      end
    end
  end


end
