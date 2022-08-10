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

ActiveRecord::Schema.define(version: 2022_08_08_053710) do

  create_table "cv_evaluation_values", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "value", null: false
    t.string "value_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "hc_constituencies", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", null: false
    t.integer "quota", null: false
    t.integer "reelection_number", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "hc_constituency_prefs", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "hc_constituency_id", null: false
    t.bigint "prefecture_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["hc_constituency_id"], name: "index_hc_constituency_prefs_on_hc_constituency_id"
    t.index ["prefecture_id"], name: "index_hc_constituency_prefs_on_prefecture_id"
  end

  create_table "hc_constituency_voters", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "hc_constituency_id", null: false
    t.integer "number_of_voter", null: false
    t.date "registration_date", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["hc_constituency_id"], name: "index_hc_constituency_voters_on_hc_constituency_id"
  end

  create_table "hc_cv_terms", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "start_date", null: false
    t.datetime "end_date", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "hc_cvs", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "hc_member_id", null: false
    t.bigint "user_id", null: false
    t.bigint "hc_cv_term_id", null: false
    t.bigint "cv_evaluation_value_id", null: false
    t.integer "my_constituency_flg"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["cv_evaluation_value_id"], name: "index_hc_cvs_on_cv_evaluation_value_id"
    t.index ["hc_cv_term_id"], name: "index_hc_cvs_on_hc_cv_term_id"
    t.index ["hc_member_id"], name: "index_hc_cvs_on_hc_member_id"
    t.index ["user_id"], name: "index_hc_cvs_on_user_id"
  end

  create_table "hc_election_times", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "election_time", null: false
    t.date "announcement_date"
    t.date "election_date"
    t.date "expiration_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "hc_members", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "politician_id", null: false
    t.bigint "hc_election_time_id", null: false
    t.integer "elected_system", null: false
    t.bigint "hc_constituency_id"
    t.date "mid_term_start_date"
    t.text "mid_term_start_reason"
    t.date "mid_term_end_date"
    t.text "mid_term_end_reason"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["hc_constituency_id"], name: "index_hc_members_on_hc_constituency_id"
    t.index ["hc_election_time_id"], name: "index_hc_members_on_hc_election_time_id"
    t.index ["politician_id"], name: "index_hc_members_on_politician_id"
  end

  create_table "hr_constituencies", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", null: false
    t.text "constituent_region"
    t.bigint "prefecture_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["prefecture_id"], name: "index_hr_constituencies_on_prefecture_id"
  end

  create_table "hr_constituency_voters", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "hr_constituency_id", null: false
    t.integer "number_of_voter", null: false
    t.date "registration_date", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["hr_constituency_id"], name: "index_hr_constituency_voters_on_hr_constituency_id"
  end

  create_table "hr_cv_terms", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "start_date", null: false
    t.datetime "end_date", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "hr_cvs", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "hr_member_id", null: false
    t.bigint "user_id", null: false
    t.bigint "hr_cv_term_id", null: false
    t.bigint "cv_evaluation_value_id", null: false
    t.integer "my_constituency_flg"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["cv_evaluation_value_id"], name: "index_hr_cvs_on_cv_evaluation_value_id"
    t.index ["hr_cv_term_id"], name: "index_hr_cvs_on_hr_cv_term_id"
    t.index ["hr_member_id"], name: "index_hr_cvs_on_hr_member_id"
    t.index ["user_id"], name: "index_hr_cvs_on_user_id"
  end

  create_table "hr_election_times", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "election_time", null: false
    t.date "announcement_date"
    t.date "election_date"
    t.date "expiration_date"
    t.date "dissolution_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "hr_members", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "politician_id", null: false
    t.bigint "hr_election_time_id", null: false
    t.integer "elected_system", null: false
    t.bigint "hr_constituency_id"
    t.bigint "hr_pr_block_id"
    t.date "mid_term_start_date"
    t.text "mid_term_start_reason"
    t.date "mid_term_end_date"
    t.text "mid_term_end_reason"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["hr_constituency_id"], name: "index_hr_members_on_hr_constituency_id"
    t.index ["hr_election_time_id"], name: "index_hr_members_on_hr_election_time_id"
    t.index ["hr_pr_block_id"], name: "index_hr_members_on_hr_pr_block_id"
    t.index ["politician_id"], name: "index_hr_members_on_politician_id"
  end

  create_table "hr_pr_blocks", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "block_name", null: false
    t.integer "quota", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "political_parties", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name_kanji", null: false
    t.string "name_kana", null: false
    t.string "abbreviation_kanji"
    t.string "abbreviation_kana"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "political_party_members", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "politician_id", null: false
    t.bigint "political_party_id", null: false
    t.date "start_belonging_date"
    t.date "end_belonging_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["political_party_id"], name: "index_political_party_members_on_political_party_id"
    t.index ["politician_id"], name: "index_political_party_members_on_politician_id"
  end

  create_table "politicians", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "last_name_kanji", limit: 5, null: false
    t.string "first_name_kanji", limit: 10
    t.string "last_name_kana", limit: 8, null: false
    t.string "first_name_kana", limit: 20
    t.text "career"
    t.string "website"
    t.string "twitter"
    t.string "youtube"
    t.string "facebook"
    t.string "other_sns"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "prefectures", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "prefecture", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "name", limit: 30, null: false
    t.string "nickname"
    t.string "image"
    t.string "email"
    t.text "tokens"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "hr_constituency_id"
    t.bigint "hc_constituency_id"
    t.bigint "prefecture_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["hc_constituency_id"], name: "index_users_on_hc_constituency_id"
    t.index ["hr_constituency_id"], name: "index_users_on_hr_constituency_id"
    t.index ["prefecture_id"], name: "index_users_on_prefecture_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  add_foreign_key "hc_constituency_prefs", "hc_constituencies"
  add_foreign_key "hc_constituency_prefs", "prefectures"
  add_foreign_key "hc_constituency_voters", "hc_constituencies"
  add_foreign_key "hc_cvs", "cv_evaluation_values"
  add_foreign_key "hc_cvs", "hc_cv_terms"
  add_foreign_key "hc_cvs", "hc_members"
  add_foreign_key "hc_cvs", "users"
  add_foreign_key "hc_members", "hc_constituencies"
  add_foreign_key "hc_members", "hc_election_times"
  add_foreign_key "hc_members", "politicians"
  add_foreign_key "hr_constituencies", "prefectures"
  add_foreign_key "hr_constituency_voters", "hr_constituencies"
  add_foreign_key "hr_cvs", "cv_evaluation_values"
  add_foreign_key "hr_cvs", "hr_cv_terms"
  add_foreign_key "hr_cvs", "hr_members"
  add_foreign_key "hr_cvs", "users"
  add_foreign_key "hr_members", "hr_constituencies"
  add_foreign_key "hr_members", "hr_election_times"
  add_foreign_key "hr_members", "hr_pr_blocks"
  add_foreign_key "hr_members", "politicians"
  add_foreign_key "political_party_members", "political_parties"
  add_foreign_key "political_party_members", "politicians"
  add_foreign_key "users", "hc_constituencies"
  add_foreign_key "users", "hr_constituencies"
  add_foreign_key "users", "prefectures"
end
