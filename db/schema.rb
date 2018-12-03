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

ActiveRecord::Schema.define(version: 20181203074936) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pgcrypto"

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

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "organization_id"
    t.string "api_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "plan", default: 0
  end

  add_foreign_key "messages", "users"
  add_foreign_key "purchases", "messages"
end
