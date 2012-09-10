# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 11) do

  create_table "areas", :force => true do |t|
    t.string   "name"
    t.integer  "lock_version", :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.string   "cycle"
    t.text     "detail"
    t.string   "detail_url"
    t.text     "throw"
    t.string   "throw_url"
    t.integer  "lock_version",      :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_group_id"
  end

  create_table "category_groups", :force => true do |t|
    t.string   "name"
    t.integer  "lock_version", :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "collect_dates", :force => true do |t|
    t.integer  "area_id"
    t.integer  "category_group_id"
    t.datetime "collect_date"
    t.integer  "lock_version",      :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "garbages", :force => true do |t|
    t.string   "name"
    t.string   "ruby"
    t.string   "image_url"
    t.integer  "category_id"
    t.text     "note"
    t.string   "gabage_station"
    t.string   "gabage_center"
    t.string   "keyword1"
    t.string   "keyword2"
    t.string   "keyword3"
    t.string   "keyword4"
    t.string   "keyword5"
    t.integer  "lock_version",   :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "logs", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.string   "action"
    t.string   "error"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "tabs", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "account"
    t.string   "name"
    t.string   "hashed_password"
    t.string   "salt"
    t.integer  "lock_version",    :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["account"], :name => "index_users_on_account", :unique => true

end
