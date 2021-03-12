# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_03_12_225701) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attacks", force: :cascade do |t|
    t.bigint "upload_id"
    t.string "source_ip"
    t.string "source_port"
    t.string "destination_ip"
    t.string "destination_port"
    t.string "duration"
    t.string "sequence_id"
    t.string "attack_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["upload_id"], name: "index_attacks_on_upload_id"
  end

  create_table "statistics", force: :cascade do |t|
    t.bigint "upload_id"
    t.integer "total_records"
    t.integer "total_attacks"
    t.integer "total_ddos"
    t.integer "total_dos"
    t.integer "total_theft"
    t.integer "total_reconnaissance"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["upload_id"], name: "index_statistics_on_upload_id"
  end

  create_table "uploads", force: :cascade do |t|
    t.integer "status"
    t.bigint "user_id"
    t.datetime "finished_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_uploads_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "admin"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "attacks", "uploads"
  add_foreign_key "statistics", "uploads"
  add_foreign_key "uploads", "users"
end
