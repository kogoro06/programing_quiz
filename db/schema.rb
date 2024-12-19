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

ActiveRecord::Schema[7.2].define(version: 2024_12_19_070053) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookmarks", force: :cascade do |t|
    t.bigint "quiz_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quiz_id"], name: "index_bookmarks_on_quiz_id"
    t.index ["user_id"], name: "index_bookmarks_on_user_id"
  end

  create_table "choices", force: :cascade do |t|
    t.string "choice1", null: false
    t.string "choice2", null: false
    t.string "choice3", null: false
    t.string "choice4", null: false
    t.bigint "question_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_choices_on_question_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "title", null: false
    t.text "text", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.string "email", null: false
  end

  create_table "past_answers", force: :cascade do |t|
    t.bigint "quiz_id", null: false
    t.bigint "user_id", null: false
    t.string "answer_content"
    t.boolean "answer_result"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quiz_id"], name: "index_past_answers_on_quiz_id"
    t.index ["user_id"], name: "index_past_answers_on_user_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.string "bio"
    t.string "studying_language"
    t.string "github_links"
    t.string "x_links"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "questions", force: :cascade do |t|
    t.text "question"
    t.integer "correct_answer", null: false
    t.string "answer_source"
    t.text "explanation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "quiz_id", null: false
  end

  create_table "quizzes", force: :cascade do |t|
    t.bigint "author_user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.index ["author_user_id"], name: "index_quizzes_on_author_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "score", null: false
    t.bigint "user_id", null: false
    t.bigint "quiz_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quiz_id"], name: "index_reviews_on_quiz_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "tag_quizzes", force: :cascade do |t|
    t.bigint "quiz_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quiz_id"], name: "index_tag_quizzes_on_quiz_id"
    t.index ["tag_id"], name: "index_tag_quizzes_on_tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.json "color", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name", null: false
    t.integer "role", default: 0, null: false
    t.integer "sign_in_count"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "bookmarks", "quizzes"
  add_foreign_key "bookmarks", "users"
  add_foreign_key "choices", "questions"
  add_foreign_key "past_answers", "quizzes"
  add_foreign_key "past_answers", "users"
  add_foreign_key "profiles", "users"
  add_foreign_key "quizzes", "users", column: "author_user_id"
  add_foreign_key "reviews", "quizzes"
  add_foreign_key "reviews", "users"
  add_foreign_key "tag_quizzes", "quizzes"
  add_foreign_key "tag_quizzes", "tags"
end
