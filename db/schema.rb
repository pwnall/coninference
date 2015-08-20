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

ActiveRecord::Schema.define(version: 20150820041812) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "credentials", force: :cascade do |t|
    t.integer  "user_id",                null: false
    t.string   "type",       limit: 32,  null: false
    t.string   "name",       limit: 128
    t.datetime "updated_at",             null: false
    t.binary   "key"
  end

  add_index "credentials", ["type", "name"], name: "index_credentials_on_type_and_name", unique: true, using: :btree
  add_index "credentials", ["type", "updated_at"], name: "index_credentials_on_type_and_updated_at", using: :btree
  add_index "credentials", ["user_id", "type"], name: "index_credentials_on_user_id_and_type", using: :btree

  create_table "devices", force: :cascade do |t|
    t.integer "room_id"
    t.string  "name",         limit: 64
    t.string  "url_name",     limit: 32,  null: false
    t.string  "key",          limit: 64,  null: false
    t.string  "push_url",     limit: 256
    t.string  "node_version", limit: 32
    t.string  "serial",       limit: 64
  end

  add_index "devices", ["key"], name: "index_devices_on_key", unique: true, using: :btree
  add_index "devices", ["room_id"], name: "index_devices_on_room_id", using: :btree
  add_index "devices", ["url_name"], name: "index_devices_on_url_name", unique: true, using: :btree

  create_table "events", force: :cascade do |t|
    t.string   "url_name",   limit: 32,  null: false
    t.integer  "user_id",                null: false
    t.string   "label",      limit: 128, null: false
    t.datetime "started_at",             null: false
    t.datetime "ended_at"
  end

  add_index "events", ["url_name"], name: "index_events_on_url_name", unique: true, using: :btree
  add_index "events", ["user_id", "started_at"], name: "index_events_on_user_id_and_started_at", using: :btree

  create_table "maps", force: :cascade do |t|
    t.string "name",     limit: 64,  null: false
    t.string "url_name", limit: 32,  null: false
    t.string "key",      limit: 64,  null: false
    t.string "push_url", limit: 256
  end

  add_index "maps", ["key"], name: "index_maps_on_key", unique: true, using: :btree
  add_index "maps", ["name"], name: "index_maps_on_name", unique: true, using: :btree
  add_index "maps", ["url_name"], name: "index_maps_on_url_name", unique: true, using: :btree

  create_table "rooms", force: :cascade do |t|
    t.integer "map_id",                  null: false
    t.string  "name",         limit: 32, null: false
    t.string  "dom_selector", limit: 32, null: false
    t.boolean "occupied",                null: false
  end

  add_index "rooms", ["dom_selector"], name: "index_rooms_on_dom_selector", unique: true, using: :btree
  add_index "rooms", ["map_id"], name: "index_rooms_on_map_id", using: :btree

  create_table "sensor_edges", force: :cascade do |t|
    t.integer  "device_id",              null: false
    t.string   "kind",        limit: 16, null: false
    t.float    "value",                  null: false
    t.datetime "created_at",             null: false
    t.datetime "device_time",            null: false
  end

  add_index "sensor_edges", ["device_id", "kind", "created_at"], name: "index_sensor_edges_on_device_id_and_kind_and_created_at", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "exuid",      limit: 32,  null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.boolean  "admin",                  null: false
    t.string   "key",        limit: 64,  null: false
    t.string   "push_url",   limit: 256
  end

  add_index "users", ["exuid"], name: "index_users_on_exuid", unique: true, using: :btree

  add_foreign_key "sensor_edges", "devices"
end
