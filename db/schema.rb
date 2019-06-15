# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_11_20_070842) do

  create_table "accounts", force: :cascade do |t|
    t.string "account_email"
    t.string "account_password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.string "request_url"
    t.datetime "access_time"
    t.time "start_time"
    t.integer "min_interval"
    t.integer "max_interval"
    t.boolean "random_exhibit"
  end

  create_table "comments", force: :cascade do |t|
    t.string "name"
    t.text "content"
    t.integer "item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_comments_on_item_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "csv"
    t.string "image1"
    t.string "image2"
    t.string "image3"
    t.string "image4"
    t.string "image5"
    t.string "image6"
    t.string "image7"
    t.string "image8"
    t.string "image9"
    t.string "image10"
    t.string "item_name"
    t.text "description"
    t.integer "category1"
    t.integer "category2"
    t.integer "category3"
    t.integer "state"
    t.integer "ship_fee"
    t.integer "ship_method"
    t.integer "ship_from"
    t.integer "ship_day"
    t.integer "purchase_application"
    t.boolean "discount"
    t.integer "price"
    t.integer "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "url"
    t.integer "count_comments"
    t.boolean "new_comment"
    t.string "tags"
    t.index ["account_id"], name: "index_items_on_account_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin_flg", default: false
    t.integer "max_account", default: 0
    t.boolean "user_flg", default: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
