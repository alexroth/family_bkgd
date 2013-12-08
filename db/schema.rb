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

ActiveRecord::Schema.define(version: 20131208040550) do

  create_table "family_affinities", force: true do |t|
    t.string   "name"
    t.integer  "membid"
    t.string   "relationship"
    t.string   "other_type_value"
    t.string   "connection_name"
    t.integer  "connection_membid"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "family_aliases", force: true do |t|
    t.string   "name"
    t.integer  "membid"
    t.string   "type_of_name"
    t.string   "alias_name"
    t.string   "alias_hash5"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "other_type_value"
  end

  create_table "family_data", force: true do |t|
    t.string   "name"
    t.string   "gender"
    t.integer  "membid"
    t.string   "father"
    t.integer  "fatherid"
    t.string   "mother"
    t.integer  "motherid"
    t.date     "birth_date"
    t.string   "birth_place"
    t.text     "comment"
    t.string   "hash5"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "override_year"
  end

  create_table "family_documents", force: true do |t|
    t.string   "doc_descrip"
    t.string   "doc_type"
    t.string   "doc_link"
    t.string   "name"
    t.integer  "membid"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "event_type"
    t.date     "event_date"
    t.string   "event_place"
    t.string   "place_type"
    t.string   "other_doc_type"
    t.string   "other_place_type"
    t.string   "other_event_type"
  end

  create_table "family_start_points", force: true do |t|
    t.string   "family_descrip"
    t.integer  "membid"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
