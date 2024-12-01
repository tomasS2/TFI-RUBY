# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2024_12_01_212941) do
  create_table "categories", force: :cascade do |t|
    t.string "category_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "name", null: false
    t.string "description", null: false
    t.decimal "price", null: false
    t.integer "stock", null: false
    t.string "colour"
    t.integer "category_id", null: false
    t.datetime "delete_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_products_on_category_id"
  end

  create_table "products_sizes", id: false, force: :cascade do |t|
    t.integer "product_id", null: false
    t.integer "size_id", null: false
    t.integer "product_size_stock"
    t.index ["product_id", "size_id"], name: "index_products_sizes_on_product_id_and_size_id"
    t.index ["size_id", "product_id"], name: "index_products_sizes_on_size_id_and_product_id"
  end

  create_table "sizes", force: :cascade do |t|
    t.string "size_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "products", "categories"
end
