# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160129115348) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "campaigns", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "newsletter_id"
    t.string   "status",        default: "Preparando"
  end

  add_index "campaigns", ["newsletter_id"], name: "index_campaigns_on_newsletter_id", using: :btree

  create_table "emails", force: :cascade do |t|
    t.string   "address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "verification_result"
  end

  add_index "emails", ["address"], name: "index_emails_on_address", unique: true, using: :btree

  create_table "list_items", force: :cascade do |t|
    t.integer  "list_id"
    t.integer  "email_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "list_items", ["email_id"], name: "index_list_items_on_email_id", using: :btree
  add_index "list_items", ["list_id"], name: "index_list_items_on_list_id", using: :btree

  create_table "lists", force: :cascade do |t|
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "file"
    t.string   "name"
    t.boolean  "import_finished", default: false
  end

  create_table "newsletters", force: :cascade do |t|
    t.string   "from"
    t.string   "subject"
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shot_events", force: :cascade do |t|
    t.integer  "shot_id"
    t.string   "service"
    t.string   "event"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.hstore   "event_hash"
  end

  add_index "shot_events", ["shot_id"], name: "index_shot_events_on_shot_id", using: :btree

  create_table "shots", force: :cascade do |t|
    t.integer  "campaign_id"
    t.datetime "queued_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "relayed_at"
    t.integer  "list_item_id"
  end

  add_index "shots", ["campaign_id"], name: "index_shots_on_campaign_id", using: :btree
  add_index "shots", ["list_item_id"], name: "index_shots_on_list_item_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username",           default: "", null: false
    t.string   "encrypted_password", default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
