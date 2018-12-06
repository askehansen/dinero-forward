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

ActiveRecord::Schema.define(version: 2018_12_06_191143) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "messages", force: :cascade do |t|
    t.uuid "user_id"
    t.string "from_email"
    t.string "from_name"
    t.string "email"
    t.string "subject"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status"
    t.integer "lock_version"
    t.text "body"
    t.text "raw_html"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "purchases", force: :cascade do |t|
    t.bigint "message_id"
    t.string "file_key"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "filename"
    t.index ["message_id"], name: "index_purchases_on_message_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.uuid "user_id"
    t.string "stripe_customer_id"
    t.string "stripe_subscription_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "organization_id"
    t.string "api_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "plan", default: 0
    t.string "email"
    t.string "persistence_token"
    t.string "single_access_token"
    t.string "encrypted_password", limit: 128
    t.string "confirmation_token", limit: 128
    t.string "remember_token", limit: 128
    t.string "stripe_customer_id"
    t.index ["email"], name: "index_users_on_email"
    t.index ["persistence_token"], name: "index_users_on_persistence_token", unique: true
    t.index ["remember_token"], name: "index_users_on_remember_token"
    t.index ["single_access_token"], name: "index_users_on_single_access_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "messages", "users"
  add_foreign_key "purchases", "messages"
end
