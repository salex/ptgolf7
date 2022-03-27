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

ActiveRecord::Schema[7.0].define(version: 2022_03_23_191407) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

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

  create_table "clubs", force: :cascade do |t|
    t.string "short_name"
    t.string "name"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "phone"
    t.string "par_in"
    t.string "par_out"
    t.string "tees"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "post_id", null: false
    t.bigint "player_id", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_comments_on_player_id"
    t.index ["post_id"], name: "index_comments_on_post_id"
  end

  create_table "games", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.date "date"
    t.string "status"
    t.string "method"
    t.text "stats"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "skins"
    t.text "par3"
    t.index ["group_id"], name: "index_games_on_group_id"
  end

  create_table "groups", force: :cascade do |t|
    t.bigint "club_id", null: false
    t.string "name"
    t.string "tees"
    t.text "preferences"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "settings"
    t.index ["club_id"], name: "index_groups_on_club_id"
  end

  create_table "players", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "nickname"
    t.boolean "use_nickname"
    t.string "tee"
    t.integer "quota"
    t.float "rquota"
    t.string "phone"
    t.boolean "is_frozen"
    t.date "last_played"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.integer "pin"
    t.string "limited"
    t.index ["group_id"], name: "index_players_on_group_id"
  end

  create_table "point_golfers", force: :cascade do |t|
    t.string "description"
    t.text "preferences"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posts", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.string "title"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "player_id"
    t.index ["group_id"], name: "index_posts_on_group_id"
  end

  create_table "rounds", force: :cascade do |t|
    t.bigint "game_id", null: false
    t.bigint "player_id", null: false
    t.string "type"
    t.date "date"
    t.integer "team"
    t.string "tee"
    t.integer "quota"
    t.integer "front"
    t.integer "back"
    t.float "quality"
    t.float "skins"
    t.float "par3"
    t.float "other"
    t.string "limited"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "total"
    t.index ["game_id"], name: "index_rounds_on_game_id"
    t.index ["player_id"], name: "index_rounds_on_player_id"
  end

  create_table "stashes", force: :cascade do |t|
    t.string "stashable_type", null: false
    t.bigint "stashable_id", null: false
    t.string "type"
    t.date "date"
    t.text "hash_data"
    t.text "text_data"
    t.text "slim"
    t.date "date_data"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stashable_type", "stashable_id"], name: "index_stashes_on_stashable_type_and_stashable_id"
    t.index ["type"], name: "index_stashes_on_type"
  end

  create_table "users", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.bigint "player_id"
    t.string "email"
    t.string "username"
    t.text "role"
    t.string "password_digest"
    t.string "reset_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_users_on_group_id"
    t.index ["player_id"], name: "index_users_on_player_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "comments", "players"
  add_foreign_key "comments", "posts"
  add_foreign_key "games", "groups"
  add_foreign_key "groups", "clubs"
  add_foreign_key "players", "groups"
  add_foreign_key "posts", "groups"
  add_foreign_key "posts", "players"
  add_foreign_key "rounds", "games"
  add_foreign_key "rounds", "players"
  add_foreign_key "users", "groups"
end
