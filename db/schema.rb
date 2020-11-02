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

ActiveRecord::Schema.define(version: 2020_10_27_060421) do

  create_table "list_items", force: :cascade do |t|
    t.string "item_id"
    t.string "resolved_id"
    t.string "given_url"
    t.string "resolved_url"
    t.string "given_title"
    t.string "resolved_title"
    t.integer "favorite"
    t.integer "status"
    t.text "excerpt"
    t.integer "is_article"
    t.integer "has_image"
    t.integer "has_video"
    t.integer "word_count"
    t.integer "time_to_read"
    t.integer "times_skipped", default: 100
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "username"
    t.boolean "archived", default: false, null: false
    t.index ["item_id"], name: "index_list_items_on_item_id", unique: true
  end

end
