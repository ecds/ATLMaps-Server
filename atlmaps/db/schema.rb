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

ActiveRecord::Schema.define(version: 20141219150449) do

  create_table "institutions", force: true do |t|
    t.string   "name"
    t.string   "geoserver"
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
    t.integer  "institution_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "layers", ["institution_id"], name: "index_layers_on_institution_id", using: :btree

  create_table "projectlayers", force: true do |t|
    t.integer  "layer_id"
    t.integer  "project_id"
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
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
