class Product < ApplicationRecord
  has_many_attached :images
  has_many :product_sizes
  has_many :sizes, through: :product_sizes
  belongs_to :category

  validates :images, presence: true, on: :create
  validates :name, presence: true
  validates :price, presence: true
  validates :price, numericality: {greater_than_or_equal_to: 0}, if: -> { price.present? }
  validates :description, presence: true
  validates :stock, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validate :image_limit


  def image_limit
    if images.length > 4
      errors.add(:images, "No puede haber más de 4 imágenes por producto.")
    end
  end

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

  def modify_global_stock(new_stock)
    if self.stock != new_stock
      self.update_column(:stock, new_stock)
    end
  end

  def modify_size_stock(sizes_data)
    #itero sobre los distintos talles con stock
    sizes_data.each do |size_data|
      product_size_edit = ProductSize.find_by(product_id: self.id, size_id: size_data[:size_id])
      #comparo el stock del talle quetengo guardado con el ingresado por parametro paraver si es nacesario actualizar
      if product_size_edit.product_size_stock != size_data[:product_size_stock].to_i
        product_size_edit.product_size_stock = size_data[:product_size_stock].to_i
        ProductSize.update_stock(self.id, size_data[:size_id], size_data[:product_size_stock].to_i)
      end
    end
  end


  def has_stock(quantity, size_id)
    if !size_id.blank? && self.product_sizes.any?
      product_size_selected = ProductSize.find_by(size_id: size_id, product_id: self.id)
      return product_size_selected.product_size_stock >= quantity
    else  
      return self.stock >= quantity
    end
  end

  def has_size_without_size_id_sent?(size_id)
    return self.product_sizes.any? ? size_id.blank? : false
  end

  def update_stock_global(stock)
    self.update_column(:stock, stock)
  end

  def update_size_stock(quantity, size_id)
    product_size_stock = ProductSize.find_by(size_id: size_id, product_id: self.id).product_size_stock
    ProductSize.update_stock(self.id, size_id, product_size_stock - quantity)
  end

  def self.search_filter(query)
    return where("name LIKE ? OR description LIKE ?", "%#{query}%", "%#{query}%")
  end
  def self.category_filter(subcategories_ids)
    return where(category_id: subcategories_ids)
  end
end
