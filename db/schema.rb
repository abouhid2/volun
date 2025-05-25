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

ActiveRecord::Schema[8.0].define(version: 2025_05_25_005438) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

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
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "cars", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.integer "seats"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "driver_name"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_cars_on_deleted_at"
    t.index ["event_id"], name: "index_cars_on_event_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text "content"
    t.bigint "event_id", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_comments_on_event_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "donation_settings", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.jsonb "types", default: [], null: false
    t.jsonb "units", default: [], null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_donation_settings_on_event_id", unique: true
  end

  create_table "donations", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.bigint "user_id", null: false
    t.string "donation_type"
    t.decimal "quantity"
    t.string "unit"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.bigint "car_id"
    t.index ["car_id"], name: "index_donations_on_car_id"
    t.index ["deleted_at"], name: "index_donations_on_deleted_at"
    t.index ["event_id"], name: "index_donations_on_event_id"
    t.index ["user_id"], name: "index_donations_on_user_id"
  end

  create_table "entities", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "logo_url"
    t.string "website"
    t.string "address"
    t.string "phone"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.bigint "user_id"
    t.index ["deleted_at"], name: "index_entities_on_deleted_at"
    t.index ["user_id"], name: "index_entities_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "date"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "entity_id"
    t.datetime "deleted_at"
    t.bigint "user_id"
    t.datetime "time"
    t.index ["deleted_at"], name: "index_events_on_deleted_at"
    t.index ["entity_id"], name: "index_events_on_entity_id"
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "inventories", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.string "item_name", null: false
    t.string "item_type", null: false
    t.decimal "quantity", precision: 10, scale: 2, default: "0.0", null: false
    t.string "unit", null: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_id", "item_type", "item_name", "unit"], name: "idx_inventory_unique_items", unique: true
    t.index ["entity_id"], name: "index_inventories_on_entity_id"
  end

  create_table "inventory_transactions", force: :cascade do |t|
    t.bigint "inventory_id", null: false
    t.bigint "event_id"
    t.bigint "donation_id"
    t.bigint "user_id", null: false
    t.string "transaction_type", null: false
    t.decimal "quantity", precision: 10, scale: 2, null: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["donation_id"], name: "index_inventory_transactions_on_donation_id"
    t.index ["event_id"], name: "index_inventory_transactions_on_event_id"
    t.index ["inventory_id"], name: "index_inventory_transactions_on_inventory_id"
    t.index ["transaction_type"], name: "index_inventory_transactions_on_transaction_type"
    t.index ["user_id"], name: "index_inventory_transactions_on_user_id"
  end

  create_table "participants", force: :cascade do |t|
    t.integer "user_id"
    t.integer "event_id"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.datetime "deleted_at"
    t.integer "car_id"
    t.index ["car_id"], name: "index_participants_on_car_id"
    t.index ["deleted_at"], name: "index_participants_on_deleted_at"
  end

  create_table "pictures", force: :cascade do |t|
    t.string "imageable_type", null: false
    t.bigint "imageable_id", null: false
    t.string "image_url"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_pictures_on_deleted_at"
    t.index ["imageable_type", "imageable_id"], name: "index_pictures_on_imageable_type_and_imageable_id"
  end

  create_table "requests", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.string "item_name"
    t.string "item_type"
    t.decimal "quantity", precision: 10, scale: 2, default: "1.0"
    t.string "unit"
    t.boolean "fulfilled", default: false
    t.datetime "fulfilled_at"
    t.string "requested_by"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "requested_at"
    t.index ["entity_id"], name: "index_requests_on_entity_id"
    t.index ["fulfilled"], name: "index_requests_on_fulfilled"
    t.index ["item_type"], name: "index_requests_on_item_type"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.datetime "deleted_at"
    t.string "telephone"
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "cars", "events"
  add_foreign_key "comments", "events"
  add_foreign_key "comments", "users"
  add_foreign_key "donation_settings", "events"
  add_foreign_key "donations", "cars"
  add_foreign_key "donations", "events"
  add_foreign_key "donations", "users"
  add_foreign_key "entities", "users"
  add_foreign_key "events", "entities"
  add_foreign_key "events", "users"
  add_foreign_key "inventories", "entities"
  add_foreign_key "inventory_transactions", "donations"
  add_foreign_key "inventory_transactions", "events"
  add_foreign_key "inventory_transactions", "inventories"
  add_foreign_key "inventory_transactions", "users"
  add_foreign_key "participants", "cars"
  add_foreign_key "requests", "entities"
end
