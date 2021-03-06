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

ActiveRecord::Schema.define(version: 20140919173245) do

  create_table "dtcs", force: true do |t|
    t.string   "code"
    t.string   "description"
    t.string   "meaning"
    t.string   "system"
    t.string   "source"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dtcs_fitments", id: false, force: true do |t|
    t.integer "dtc_id"
    t.integer "fitment_id"
  end

  create_table "fitments", force: true do |t|
    t.string   "make"
    t.string   "year"
    t.string   "model"
    t.string   "engine"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "indices", force: true do |t|
    t.integer  "miner"
    t.string   "mode"
    t.integer  "make"
    t.integer  "year"
    t.integer  "model"
    t.integer  "engine"
    t.integer  "system"
    t.integer  "dtc"
    t.boolean  "complete",   default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
