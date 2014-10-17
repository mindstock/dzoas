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

ActiveRecord::Schema.define(version: 20141017074333) do

  create_table "bags", force: true do |t|
    t.string   "sheet"
    t.integer  "is_nickelclad_top"
    t.integer  "nickelclad_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "departments", force: true do |t|
    t.string   "name"
    t.string   "remark"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employees", force: true do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "address"
    t.string   "remark"
    t.integer  "department_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "merges", force: true do |t|
    t.string   "merge"
    t.string   "thickness"
    t.string   "wide"
    t.string   "length"
    t.string   "allowance"
    t.integer  "is_declicacy"
    t.integer  "plan_id"
    t.string   "to"
    t.string   "final_sheet"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", force: true do |t|
    t.string   "title"
    t.string   "content"
    t.string   "complete_at"
    t.string   "remark"
    t.integer  "type"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nickelclads", force: true do |t|
    t.string   "thickness"
    t.string   "wide"
    t.string   "length"
    t.string   "to"
    t.string   "allowance"
    t.integer  "is_declicacy"
    t.integer  "status"
    t.integer  "plan_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "real_final_sheet"
    t.string   "real_finish_at"
    t.string   "merge"
  end

  create_table "plans", force: true do |t|
    t.string   "final_sheet"
    t.string   "final_piece"
    t.string   "final_row"
    t.string   "finish_at"
    t.string   "real_finish_at"
    t.integer  "is_urgency"
    t.integer  "status"
    t.string   "remark"
    t.integer  "tape_id"
    t.integer  "department_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "real_final_sheet"
    t.string   "merge",            default: "0"
    t.string   "tape_merge"
    t.integer  "place_num"
  end

  create_table "powers", force: true do |t|
    t.integer  "parent_id"
    t.string   "name"
    t.string   "url"
    t.string   "remark"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quclity_checks", force: true do |t|
    t.integer  "is_standard"
    t.string   "remark"
    t.integer  "plan_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", force: true do |t|
    t.string   "name"
    t.string   "remark"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_powers", id: false, force: true do |t|
    t.integer "role_id"
    t.integer "power_id"
  end

  create_table "tapes", force: true do |t|
    t.string   "from"
    t.string   "place"
    t.string   "texture"
    t.string   "thickness"
    t.string   "wide"
    t.string   "length"
    t.integer  "raw_weight"
    t.integer  "put_weight"
    t.integer  "out_weight"
    t.integer  "residue_weight"
    t.string   "tape_num"
    t.date     "created_at"
    t.datetime "updated_at"
    t.integer  "status",         default: 0
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.integer  "role_id"
  end

  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "welcomes", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
