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

ActiveRecord::Schema.define(version: 20170816053549) do

  create_table "material_units", force: :cascade do |t|
    t.integer  "material_id"
    t.integer  "unit_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["material_id"], name: "index_material_units_on_material_id"
    t.index ["unit_id"], name: "index_material_units_on_unit_id"
  end

  create_table "materials", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_materials_on_name"
  end

  create_table "products", force: :cascade do |t|
    t.integer  "material_id"
    t.string   "name"
    t.string   "price"
    t.string   "weight"
    t.string   "bundle"
    t.string   "image"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["material_id"], name: "index_products_on_material_id"
    t.index ["name"], name: "index_products_on_name"
  end

  create_table "recipe_materials", force: :cascade do |t|
    t.integer  "recipe_id"
    t.integer  "material_id"
    t.integer  "unit_id"
    t.string   "value"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["material_id"], name: "index_recipe_materials_on_material_id"
    t.index ["recipe_id"], name: "index_recipe_materials_on_recipe_id"
    t.index ["unit_id"], name: "index_recipe_materials_on_unit_id"
  end

  create_table "recipe_products", force: :cascade do |t|
    t.integer  "recipe_id"
    t.integer  "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_recipe_products_on_product_id"
    t.index ["recipe_id"], name: "index_recipe_products_on_recipe_id"
  end

  create_table "recipes", force: :cascade do |t|
    t.string   "title",           null: false
    t.string   "url"
    t.string   "image"
    t.string   "writer"
    t.string   "subtitle"
    t.string   "serving"
    t.string   "recipe_material"
    t.string   "missed_material"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["url"], name: "index_recipes_on_url"
  end

  create_table "units", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
