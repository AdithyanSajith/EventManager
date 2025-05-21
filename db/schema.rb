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

ActiveRecord::Schema[7.2].define(version: 2025_05_20_115844) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.bigint "host_id", null: false
    t.bigint "category_id", null: false
    t.bigint "venue_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_events_on_category_id"
    t.index ["host_id"], name: "index_events_on_host_id"
    t.index ["venue_id"], name: "index_events_on_venue_id"
  end

  create_table "hosts", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_hosts_on_email", unique: true
    t.index ["reset_password_token"], name: "index_hosts_on_reset_password_token", unique: true
  end

  create_table "managed_events", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.bigint "host_id", null: false
    t.bigint "category_id", null: false
    t.bigint "venue_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_managed_events_on_category_id"
    t.index ["host_id"], name: "index_managed_events_on_host_id"
    t.index ["venue_id"], name: "index_managed_events_on_venue_id"
  end

  create_table "participants", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.string "city"
    t.date "birthdate"
    t.string "interest"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_participants_on_email", unique: true
    t.index ["reset_password_token"], name: "index_participants_on_reset_password_token", unique: true
  end

  create_table "payments", force: :cascade do |t|
    t.decimal "amount"
    t.string "status"
    t.datetime "paid_at"
    t.bigint "registration_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "card_number"
    t.index ["registration_id"], name: "index_payments_on_registration_id"
  end

  create_table "registrations", force: :cascade do |t|
    t.string "status"
    t.bigint "participant_id", null: false
    t.bigint "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_registrations_on_event_id"
    t.index ["participant_id"], name: "index_registrations_on_participant_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "rating"
    t.text "comment"
    t.bigint "participant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reviewable_type", null: false
    t.bigint "reviewable_id", null: false
    t.index ["participant_id", "reviewable_id", "reviewable_type"], name: "index_reviews_on_participant_and_reviewable", unique: true
    t.index ["participant_id"], name: "index_reviews_on_participant_id"
    t.index ["reviewable_type", "reviewable_id"], name: "index_reviews_on_reviewable"
  end

  create_table "tickets", force: :cascade do |t|
    t.bigint "registration_id", null: false
    t.string "ticket_number"
    t.datetime "issued_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "paid", default: false
    t.index ["registration_id"], name: "index_tickets_on_registration_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "role"
    t.text "interest"
    t.string "city"
    t.date "birthdate"
    t.string "organisation"
    t.string "website"
    t.string "number"
    t.text "bio"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "venues", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "city"
    t.integer "capacity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "host_id", null: false
    t.string "location"
    t.index ["host_id"], name: "index_venues_on_host_id"
  end

  add_foreign_key "events", "categories"
  add_foreign_key "events", "venues"
  add_foreign_key "managed_events", "categories"
  add_foreign_key "managed_events", "hosts"
  add_foreign_key "managed_events", "venues"
  add_foreign_key "payments", "registrations"
  add_foreign_key "registrations", "events"
  add_foreign_key "tickets", "registrations"
  add_foreign_key "venues", "hosts"
end
