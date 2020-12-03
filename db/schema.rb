# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_12_01_151231) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "fuzzystrmatch"
  enable_extension "plpgsql"
  enable_extension "postgis"
  enable_extension "postgis_tiger_geocoder"
  enable_extension "postgis_topology"

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

  create_table "categories", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories_tags", id: false, force: :cascade do |t|
    t.integer "category_id"
    t.integer "tag_id"
    t.index ["category_id"], name: "index_categories_tags_on_category_id"
    t.index ["tag_id"], name: "index_categories_tags_on_tag_id"
  end

  create_table "collaborations", id: :serial, force: :cascade do |t|
    t.integer "project_id"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ecds_rails_auth_engine_logins", force: :cascade do |t|
    t.string "who"
    t.string "token"
    t.string "provider"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_ecds_rails_auth_engine_logins_on_user_id"
  end

  create_table "historic_downtown", primary_key: "ogc_fid", id: :serial, force: :cascade do |t|
    t.string "originalproperties"
    t.string "title"
    t.string "images"
    t.string "description"
    t.geometry "wkb_geometry", limit: {:srid=>4326, :type=>"st_point"}
    t.index ["wkb_geometry"], name: "historic_downtown_wkb_geometry_geom_idx", using: :gist
  end

  create_table "institutions", id: :serial, force: :cascade do |t|
    t.string "name", limit: 510
    t.string "geoserver", limit: 510
    t.string "icon", limit: 510
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "srid", limit: 50
  end

  create_table "layers", id: :serial, force: :cascade do |t|
    t.string "name", limit: 510
    t.string "slug", limit: 510
    t.text "keywords"
    t.string "description", limit: 510
    t.string "url", limit: 510
    t.string "layer", limit: 510
    t.datetime "date"
    t.string "layer_type", limit: 510
    t.integer "minzoom"
    t.integer "maxzoom"
    t.decimal "minx", precision: 10, scale: 8
    t.decimal "miny", precision: 10, scale: 8
    t.decimal "maxx", precision: 10, scale: 8
    t.decimal "maxy", precision: 10, scale: 8
    t.boolean "active"
    t.integer "institution_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "layers_tags", id: false, force: :cascade do |t|
    t.integer "layer_id"
    t.integer "tag_id"
  end

  create_table "logins", id: :serial, force: :cascade do |t|
    t.string "identification", null: false
    t.string "password_digest"
    t.string "oauth2_token", null: false
    t.string "uid"
    t.string "single_use_oauth2_token"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "provider"
    t.boolean "email_confirmed", default: false
    t.string "confirm_token"
  end

  create_table "neighborhoods", id: :serial, force: :cascade do |t|
    t.string "name"
    t.geometry "polygon", limit: {:srid=>0, :type=>"multi_polygon"}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "oauth_access_grants", id: :serial, force: :cascade do |t|
    t.integer "resource_owner_id", null: false
    t.integer "application_id", null: false
    t.string "token", limit: 510, null: false
    t.integer "expires_in", null: false
    t.text "redirect_uri", null: false
    t.datetime "created_at", null: false
    t.datetime "revoked_at"
    t.string "scopes", limit: 510
    t.index ["token"], name: "oauth_access_grants_token_key", unique: true
  end

  create_table "oauth_access_tokens", id: :serial, force: :cascade do |t|
    t.integer "resource_owner_id"
    t.integer "application_id"
    t.string "token", limit: 510, null: false
    t.string "refresh_token", limit: 510
    t.integer "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at", null: false
    t.string "scopes", limit: 510
    t.index ["refresh_token"], name: "oauth_access_tokens_refresh_token_key", unique: true
    t.index ["token"], name: "oauth_access_tokens_token_key", unique: true
  end

  create_table "oauth_applications", id: :serial, force: :cascade do |t|
    t.string "name", limit: 510, null: false
    t.string "uid", limit: 510, null: false
    t.string "secret", limit: 510, null: false
    t.text "redirect_uri", null: false
    t.string "scopes", limit: 510, default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["uid"], name: "oauth_applications_uid_key", unique: true
  end

  create_table "projectlayers", id: :serial, force: :cascade do |t|
    t.integer "layer_id"
    t.integer "project_id"
    t.integer "position"
    t.string "marker", limit: 510
    t.string "layer_type", limit: 510
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", id: :serial, force: :cascade do |t|
    t.string "name", limit: 510
    t.string "description", limit: 500
    t.decimal "center_lat", precision: 10, scale: 8, default: "33.754401", null: false
    t.decimal "center_lng", precision: 10, scale: 8, default: "-84.38981", null: false
    t.integer "zoom_level", default: 13, null: false
    t.string "default_base_map", limit: 510, default: "street", null: false
    t.boolean "saved"
    t.boolean "published"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "featured", default: false
    t.text "intro"
    t.text "media"
    t.integer "template_id"
    t.string "card", limit: 255
    t.string "photo"
    t.index ["template_id"], name: "index_projects_on_template_id"
  end

  create_table "raster_layer_projects", id: :serial, force: :cascade do |t|
    t.integer "raster_layer_id"
    t.integer "project_id"
    t.integer "marker"
    t.string "data_format", limit: 510
    t.integer "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "raster_layers", id: :serial, force: :cascade do |t|
    t.string "name", limit: 510
    t.text "keywords"
    t.text "description"
    t.string "workspace", limit: 510
    t.string "title", limit: 510
    t.datetime "date"
    t.integer "minzoom"
    t.integer "maxzoom"
    t.decimal "minx", precision: 100, scale: 8
    t.decimal "miny", precision: 100, scale: 8
    t.decimal "maxx", precision: 100, scale: 8
    t.decimal "maxy", precision: 100, scale: 8
    t.boolean "active"
    t.integer "institution_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "year"
    t.geometry "boundingbox", limit: {:srid=>4326, :type=>"st_polygon"}
    t.string "thumb"
    t.string "attribution"
    t.index ["boundingbox"], name: "index_raster_layers_on_boundingbox", using: :gist
  end

  create_table "raster_layers_tags", id: :serial, force: :cascade do |t|
    t.integer "raster_layer_id"
    t.integer "tag_id"
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name", limit: 510
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "heading", limit: 255
    t.string "loclink", limit: 255
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "tags_vector_layers", id: :serial, force: :cascade do |t|
    t.integer "vector_layer_id"
    t.integer "tag_id"
  end

  create_table "templates", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "user_taggeds", id: :serial, force: :cascade do |t|
    t.integer "raster_layer_id"
    t.integer "vector_layer_id"
    t.integer "tag_id"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["raster_layer_id"], name: "index_user_taggeds_on_raster_layer_id"
    t.index ["tag_id"], name: "index_user_taggeds_on_tag_id"
    t.index ["user_id"], name: "index_user_taggeds_on_user_id"
    t.index ["vector_layer_id"], name: "index_user_taggeds_on_vector_layer_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "username", limit: 510
    t.string "displayname", limit: 510
    t.string "email", default: ""
    t.integer "institution_id"
    t.string "avatar", limit: 510
    t.string "twitter", limit: 510
    t.boolean "admin"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip", limit: 510
    t.string "last_sign_in_ip", limit: 510
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "provider"
    t.string "uid"
    t.index ["email"], name: "users_email_key", unique: true
  end

  create_table "vector_features", id: :serial, force: :cascade do |t|
    t.string "name"
    t.json "properties"
    t.string "geometry_type"
    t.geometry "geometry_collection", limit: {:srid=>4326, :type=>"geometry_collection"}
    t.integer "vector_layer_id"
    t.geometry "point", limit: {:srid=>4326, :type=>"st_point"}
    t.geometry "multi_point", limit: {:srid=>4326, :type=>"multi_point"}
    t.geometry "polygon", limit: {:srid=>4326, :type=>"st_polygon"}
    t.geometry "multi_polygon", limit: {:srid=>4326, :type=>"multi_polygon"}
    t.geometry "line_string", limit: {:srid=>4326, :type=>"line_string"}
    t.geometry "multi_line_string", limit: {:srid=>4326, :type=>"multi_line_string"}
    t.index ["vector_layer_id"], name: "index_vector_features_on_vector_layer_id"
  end

  create_table "vector_layer_project", force: :cascade do |t|
    t.bigint "vector_layer_id"
    t.bigint "project_id"
    t.integer "position"
    t.integer "marker"
    t.string "data_format"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["project_id"], name: "index_vector_layer_project_on_project_id"
    t.index ["vector_layer_id"], name: "index_vector_layer_project_on_vector_layer_id"
  end

  create_table "vector_layer_projects", id: :serial, force: :cascade do |t|
    t.integer "vector_layer_id"
    t.integer "project_id"
    t.integer "marker"
    t.integer "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "brewer_scheme"
    t.string "property"
    t.integer "steps"
    t.jsonb "color_map", default: {}
    t.integer "order"
    t.string "brewer_group"
    t.boolean "manual_steps"
    t.text "color"
  end

  create_table "vector_layers", id: :serial, force: :cascade do |t|
    t.string "name", limit: 510
    t.text "keywords"
    t.text "description"
    t.string "url", limit: 500
    t.datetime "date"
    t.integer "minzoom"
    t.integer "maxzoom"
    t.decimal "minx", precision: 100, scale: 8
    t.decimal "miny", precision: 100, scale: 8
    t.decimal "maxx", precision: 100, scale: 8
    t.decimal "maxy", precision: 100, scale: 8
    t.boolean "active"
    t.integer "institution_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "year"
    t.string "title", limit: 255
    t.string "tmp_type", limit: 255
    t.geometry "boundingbox", limit: {:srid=>4326, :type=>"st_polygon"}
    t.string "attribution"
    t.string "workspace"
    t.string "property_id"
    t.string "default_break_property"
    t.jsonb "color_map"
    t.integer "data_type"
    t.integer "geometry_type"
    t.jsonb "tmp_geojson"
    t.integer "data_format"
    t.boolean "remote"
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.jsonb "object"
    t.jsonb "object_changes"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
end
