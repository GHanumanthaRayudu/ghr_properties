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

ActiveRecord::Schema[8.0].define(version: 2025_10_03_210000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "favorites", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "property_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["property_id"], name: "index_favorites_on_property_id"
    t.index ["user_id", "property_id"], name: "index_favorites_on_user_id_and_property_id", unique: true
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "inquiries", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.bigint "property_id", null: false
    t.text "message", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_inquiries_on_customer_id"
    t.index ["property_id", "customer_id"], name: "index_inquiries_on_property_id_and_customer_id"
    t.index ["property_id"], name: "index_inquiries_on_property_id"
    t.index ["status"], name: "index_inquiries_on_status"
  end

  create_table "messages", force: :cascade do |t|
    t.text "content"
    t.bigint "sender_id", null: false
    t.bigint "receiver_id", null: false
    t.bigint "property_id", null: false
    t.boolean "read"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "subject"
    t.index ["property_id"], name: "index_messages_on_property_id"
    t.index ["receiver_id"], name: "index_messages_on_receiver_id"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
  end

  create_table "properties", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.decimal "price"
    t.text "address"
    t.string "city"
    t.string "state"
    t.string "zip_code"
    t.decimal "latitude"
    t.decimal "longitude"
    t.integer "bedrooms"
    t.integer "bathrooms"
    t.decimal "area"
    t.boolean "furnished"
    t.boolean "parking"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "listing_type"
    t.text "amenities"
    t.date "available_from"
    t.string "pincode"
    t.integer "status", default: 0, null: false
    t.integer "property_type", default: 0, null: false
    t.index ["property_type"], name: "index_properties_on_property_type"
    t.index ["status"], name: "index_properties_on_status"
    t.index ["user_id"], name: "index_properties_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "property_id", null: false
    t.bigint "user_id", null: false
    t.integer "rating"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["property_id"], name: "index_reviews_on_property_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "property_id", null: false
    t.bigint "buyer_id", null: false
    t.bigint "seller_id", null: false
    t.string "status"
    t.string "transaction_type"
    t.decimal "amount"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["buyer_id"], name: "index_transactions_on_buyer_id"
    t.index ["property_id"], name: "index_transactions_on_property_id"
    t.index ["seller_id"], name: "index_transactions_on_seller_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 2, null: false
    t.string "phone_number"
    t.string "otp_code"
    t.datetime "otp_sent_at"
    t.datetime "phone_verified_at"
    t.integer "otp_attempts", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["phone_number"], name: "index_users_on_phone_number", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role"], name: "index_users_on_role"
  end

  add_foreign_key "favorites", "properties"
  add_foreign_key "favorites", "users"
  add_foreign_key "inquiries", "properties"
  add_foreign_key "inquiries", "users", column: "customer_id"
  add_foreign_key "messages", "properties"
  add_foreign_key "messages", "users", column: "receiver_id"
  add_foreign_key "messages", "users", column: "sender_id"
  add_foreign_key "properties", "users"
  add_foreign_key "reviews", "properties"
  add_foreign_key "reviews", "users"
  add_foreign_key "transactions", "properties"
  add_foreign_key "transactions", "users", column: "buyer_id"
  add_foreign_key "transactions", "users", column: "seller_id"
end
