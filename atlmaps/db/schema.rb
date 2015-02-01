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

ActiveRecord::Schema.define(version: 20150201013329) do

  create_table "institutions", force: true do |t|
    t.string   "name"
    t.string   "geoserver"
    t.string   "icon"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "layers", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "keywords"
    t.string   "description"
    t.string   "url"
    t.string   "layer"
    t.datetime "date"
    t.string   "layer_type"
    t.integer  "minzoom"
    t.integer  "maxzoom"
    t.decimal  "minx",           precision: 10, scale: 8
    t.decimal  "miny",           precision: 10, scale: 8
    t.decimal  "maxx",           precision: 10, scale: 8
    t.decimal  "maxy",           precision: 10, scale: 8
    t.boolean  "active",                                  default: true
    t.integer  "institution_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "layers", ["institution_id"], name: "index_layers_on_institution_id", using: :btree

  create_table "layers_tags", id: false, force: true do |t|
    t.integer "layer_id"
    t.integer "tag_id"
  end

  add_index "layers_tags", ["layer_id"], name: "index_layers_tags_on_layer_id", using: :btree
  add_index "layers_tags", ["tag_id"], name: "index_layers_tags_on_tag_id", using: :btree

  create_table "oauth_access_grants", force: true do |t|
    t.integer  "resource_owner_id", null: false
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.integer  "expires_in",        null: false
    t.text     "redirect_uri",      null: false
    t.datetime "created_at",        null: false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

  create_table "oauth_access_tokens", force: true do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",             null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        null: false
    t.string   "scopes"
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", force: true do |t|
    t.string   "name",                      null: false
    t.string   "uid",                       null: false
    t.string   "secret",                    null: false
    t.text     "redirect_uri",              null: false
    t.string   "scopes",       default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

  create_table "projectlayers", force: true do |t|
    t.integer  "layer_id"
    t.integer  "project_id"
    t.string   "marker"
    t.string   "layer_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "projectlayers", ["layer_id"], name: "index_projectlayers_on_layer_id", using: :btree
  add_index "projectlayers", ["project_id"], name: "index_projectlayers_on_project_id", using: :btree

  create_table "projects", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.boolean  "saved",       default: false
    t.boolean  "published",   default: false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "projects", ["user_id"], name: "index_projects_on_user_id", using: :btree

  create_table "tags", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "displayname"
    t.string   "email",                  default: "",    null: false
    t.integer  "institution_id"
    t.string   "avatar"
    t.string   "twitter"
    t.boolean  "admin",                  default: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["institution_id"], name: "index_users_on_institution_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
