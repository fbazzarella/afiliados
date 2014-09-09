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

ActiveRecord::Schema.define(version: 20140908182139) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "campaigns", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "emails", force: true do |t|
    t.string   "address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "verification_result"
  end

  add_index "emails", ["address"], name: "index_emails_on_address", unique: true, using: :btree

  create_table "shot_events", force: true do |t|
    t.integer  "shot_id"
    t.string   "service"
    t.string   "event"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.hstore   "event_hash"
  end

  add_index "shot_events", ["shot_id"], name: "index_shot_events_on_shot_id", using: :btree

  create_table "shots", force: true do |t|
    t.integer  "email_id"
    t.integer  "campaign_id"
    t.datetime "queued_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shots", ["campaign_id"], name: "index_shots_on_campaign_id", using: :btree
  add_index "shots", ["email_id"], name: "index_shots_on_email_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "username",           default: "", null: false
    t.string   "encrypted_password", default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
