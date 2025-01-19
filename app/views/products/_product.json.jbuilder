json.extract! product, :id, :name, :description, :price, :stock, :colour_id, :category_id, :created_at, :updated_at
json.url product_url(product, format: :json)
