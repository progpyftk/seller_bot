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

ActiveRecord::Schema.define(version: 2022_06_07_194625) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "items", primary_key: "ml_item_id", id: :string, force: :cascade do |t|
    t.string "title"
    t.float "price"
    t.float "base_price"
    t.integer "available_quantity"
    t.integer "sold_quantity"
    t.string "logistic_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "seller_id"
    t.index ["seller_id"], name: "index_items_on_seller_id"
  end

  create_table "sellers", primary_key: "ml_seller_id", id: :string, force: :cascade do |t|
    t.string "nickname"
    t.string "code"
    t.string "access_token"
    t.string "refresh_token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end