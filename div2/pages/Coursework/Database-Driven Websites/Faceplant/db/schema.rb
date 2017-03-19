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

ActiveRecord::Schema.define(version: 20150506161820) do

  create_table "cultivars", force: :cascade do |t|
    t.string  "name"
    t.integer "species_id"
  end

  add_index "cultivars", ["species_id"], name: "index_cultivars_on_species_id"

  create_table "entries", force: :cascade do |t|
    t.date    "date"
    t.string  "title"
    t.text    "text"
    t.integer "plant_id"
  end

  add_index "entries", ["plant_id"], name: "index_entries_on_plant_id"

  create_table "friendships", force: :cascade do |t|
    t.integer "friendable_id"
    t.integer "friend_id"
    t.integer "blocker_id"
    t.boolean "pending",       default: true
  end

  add_index "friendships", ["friendable_id", "friend_id"], name: "index_friendships_on_friendable_id_and_friend_id", unique: true

  create_table "genus", force: :cascade do |t|
    t.string "name"
  end

  create_table "locations", force: :cascade do |t|
    t.string  "name"
    t.text    "description"
    t.boolean "current"
    t.integer "user_id"
  end

  add_index "locations", ["user_id"], name: "index_locations_on_user_id"

  create_table "pictures", force: :cascade do |t|
    t.string  "filepath"
    t.date    "taken"
    t.text    "description"
    t.boolean "is_disp"
    t.integer "entry_id"
  end

  add_index "pictures", ["entry_id"], name: "index_pictures_on_entry_id"

  create_table "plants", force: :cascade do |t|
    t.string  "name"
    t.text    "description"
    t.date    "obtained"
    t.boolean "alive"
    t.integer "location_id"
    t.integer "pot_id"
    t.integer "cultivar_id"
  end

  add_index "plants", ["cultivar_id"], name: "index_plants_on_cultivar_id"
  add_index "plants", ["location_id"], name: "index_plants_on_location_id"
  add_index "plants", ["pot_id"], name: "index_plants_on_pot_id"

  create_table "pots", force: :cascade do |t|
    t.boolean "owned"
    t.integer "width"
    t.integer "height"
    t.string  "color"
    t.string  "material"
    t.integer "user_id"
  end

  add_index "pots", ["user_id"], name: "index_pots_on_user_id"

  create_table "repottings", force: :cascade do |t|
    t.date    "date"
    t.integer "pot_id"
    t.integer "plant_id"
  end

  add_index "repottings", ["plant_id"], name: "index_repottings_on_plant_id"
  add_index "repottings", ["pot_id"], name: "index_repottings_on_pot_id"

  create_table "species", force: :cascade do |t|
    t.string  "name"
    t.integer "genus_id"
  end

  add_index "species", ["genus_id"], name: "index_species_on_genus_id"

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
  end

  create_table "waterings", force: :cascade do |t|
    t.date    "date"
    t.integer "plant_id"
  end

  add_index "waterings", ["plant_id"], name: "index_waterings_on_plant_id"

end
