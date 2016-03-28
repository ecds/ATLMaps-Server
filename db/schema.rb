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

ActiveRecord::Schema.define(version: 20160328165028) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories_tags", id: false, force: true do |t|
    t.integer "category_id"
    t.integer "tag_id"
  end

  add_index "categories_tags", ["category_id"], name: "index_categories_tags_on_category_id", using: :btree
  add_index "categories_tags", ["tag_id"], name: "index_categories_tags_on_tag_id", using: :btree

  create_table "collaborations", force: true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "collaborations", ["project_id"], name: "atlmaps_api_dev_collaborations_project_id1_idx", using: :btree
  add_index "collaborations", ["user_id"], name: "atlmaps_api_dev_collaborations_user_id2_idx", using: :btree

  create_table "institutions", force: true do |t|
    t.string   "name"
    t.string   "geoserver"
    t.string   "icon"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "layers_tags", id: false, force: true do |t|
    t.integer "layer_id"
    t.integer "tag_id"
  end

  add_index "layers_tags", ["layer_id"], name: "atlmaps_api_dev_layers_tags_layer_id0_idx", using: :btree
  add_index "layers_tags", ["tag_id"], name: "atlmaps_api_dev_layers_tags_tag_id1_idx", using: :btree

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

  add_index "oauth_access_grants", ["token"], name: "atlmaps_api_dev_oauth_access_grants_token1_idx", unique: true, using: :btree

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

  add_index "oauth_access_tokens", ["refresh_token"], name: "atlmaps_api_dev_oauth_access_tokens_refresh_token2_idx", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "atlmaps_api_dev_oauth_access_tokens_resource_owner_id3_idx", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "atlmaps_api_dev_oauth_access_tokens_token1_idx", unique: true, using: :btree

  create_table "oauth_applications", force: true do |t|
    t.string   "name",         null: false
    t.string   "uid",          null: false
    t.string   "secret",       null: false
    t.text     "redirect_uri", null: false
    t.string   "scopes",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_applications", ["uid"], name: "atlmaps_api_dev_oauth_applications_uid1_idx", unique: true, using: :btree

  create_table "projects", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.decimal  "center_lat",       precision: 10, scale: 8, default: 33.754401, null: false
    t.decimal  "center_lng",       precision: 10, scale: 8, default: -84.38981, null: false
    t.integer  "zoom_level",                                default: 13,        null: false
    t.string   "default_base_map",                          default: "street",  null: false
    t.boolean  "saved"
    t.boolean  "published",                                 default: false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "featured",                                  default: false
    t.text     "intro"
    t.text     "media"
    t.integer  "template_id"
    t.string   "card"
  end

  add_index "projects", ["template_id"], name: "index_projects_on_template_id", using: :btree
  add_index "projects", ["user_id"], name: "atlmaps_api_dev_projects_user_id1_idx", using: :btree

  create_table "raster_layer_projects", force: true do |t|
    t.integer  "raster_layer_id"
    t.integer  "project_id"
    t.integer  "marker"
    t.string   "data_format"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "raster_layer_projects", ["project_id"], name: "atlmaps_api_dev_raster_layer_projects_project_id2_idx", using: :btree
  add_index "raster_layer_projects", ["raster_layer_id"], name: "atlmaps_api_dev_raster_layer_projects_raster_layer_id1_idx", using: :btree

  create_table "raster_layers", force: true do |t|
    t.string   "name"
    t.string   "keywords"
    t.string   "description",    limit: 500
    t.datetime "date"
    t.string   "data_format"
    t.integer  "minzoom"
    t.integer  "maxzoom"
    t.decimal  "minx",                       precision: 10, scale: 8
    t.decimal  "miny",                       precision: 10, scale: 8
    t.decimal  "maxx",                       precision: 10, scale: 8
    t.decimal  "maxy",                       precision: 10, scale: 8
    t.boolean  "active",                                              default: false
    t.integer  "institution_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.string   "workspace"
    t.integer  "year"
    t.string   "data_type"
  end

  add_index "raster_layers", ["institution_id"], name: "atlmaps_api_dev_raster_layers_institution_id1_idx", using: :btree

  create_table "raster_layers_tags", force: true do |t|
    t.integer "raster_layer_id"
    t.integer "tag_id"
  end

  add_index "raster_layers_tags", ["raster_layer_id"], name: "atlmaps_api_dev_raster_layers_tags_raster_layer_id1_idx", using: :btree
  add_index "raster_layers_tags", ["tag_id"], name: "atlmaps_api_dev_raster_layers_tags_tag_id2_idx", using: :btree

  create_table "tags", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags_vector_layers", force: true do |t|
    t.integer "vector_layer_id"
    t.integer "tag_id"
  end

  add_index "tags_vector_layers", ["tag_id"], name: "atlmaps_api_dev_tags_vector_layers_tag_id2_idx", using: :btree
  add_index "tags_vector_layers", ["vector_layer_id"], name: "atlmaps_api_dev_tags_vector_layers_vector_layer_id1_idx", using: :btree

  create_table "templates", force: true do |t|
    t.string "name"
  end

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "displayname"
    t.string   "email",                            null: false
    t.integer  "institution_id"
    t.string   "avatar"
    t.string   "twitter"
    t.integer  "admin",                  limit: 2
    t.string   "encrypted_password",               null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "atlmaps_api_dev_users_email1_idx", unique: true, using: :btree
  add_index "users", ["institution_id"], name: "atlmaps_api_dev_users_institution_id3_idx", using: :btree
  add_index "users", ["reset_password_token"], name: "atlmaps_api_dev_users_reset_password_token2_idx", unique: true, using: :btree

  create_table "vector_layer_projects", force: true do |t|
    t.integer  "vector_layer_id"
    t.integer  "project_id"
    t.integer  "marker"
    t.string   "data_format"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vector_layer_projects", ["project_id"], name: "atlmaps_api_dev_vector_layer_projects_project_id2_idx", using: :btree
  add_index "vector_layer_projects", ["vector_layer_id"], name: "atlmaps_api_dev_vector_layer_projects_vector_layer_id1_idx", using: :btree

  create_table "vector_layers", force: true do |t|
    t.string   "name"
    t.string   "keywords"
    t.string   "description"
    t.datetime "date"
    t.string   "data_format"
    t.integer  "minzoom"
    t.integer  "maxzoom"
    t.decimal  "minx",           precision: 10, scale: 8
    t.decimal  "miny",           precision: 10, scale: 8
    t.decimal  "maxx",           precision: 10, scale: 8
    t.decimal  "maxy",           precision: 10, scale: 8
    t.boolean  "active",                                  default: false
    t.integer  "institution_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
    t.integer  "year"
    t.string   "title"
    t.string   "data_type"
  end

  add_index "vector_layers", ["institution_id"], name: "atlmaps_api_dev_vector_layers_institution_id1_idx", using: :btree

end
