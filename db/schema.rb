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

ActiveRecord::Schema.define(version: 20170719035832) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_keys", force: :cascade do |t|
    t.string "api_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["api_key"], name: "index_api_keys_on_api_key", unique: true
  end

  create_table "charts", force: :cascade do |t|
    t.bigint "project_id"
    t.bigint "space_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_charts_on_project_id"
    t.index ["space_id"], name: "index_charts_on_space_id"
    t.index ["user_id"], name: "index_charts_on_user_id"
  end

  create_table "contact_us", force: :cascade do |t|
    t.string "email"
    t.string "subject"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "descrips", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.string "icon"
    t.string "lang", default: "en"
  end

  create_table "emails", force: :cascade do |t|
    t.string "email", limit: 35
    t.boolean "checked", default: false
    t.boolean "primary", default: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_emails_on_email"
    t.index ["user_id"], name: "index_emails_on_user_id"
  end

  create_table "faqs", force: :cascade do |t|
    t.string "lang", default: "en"
    t.string "question"
    t.text "answer"
  end

  create_table "features", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_features_on_name"
  end

  create_table "logs", force: :cascade do |t|
    t.text "description"
    t.string "action", limit: 20
    t.bigint "user_id"
    t.integer "user_action_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_action_id"], name: "index_logs_on_user_action_id"
    t.index ["user_id"], name: "index_logs_on_user_id"
  end

  create_table "plan_features", force: :cascade do |t|
    t.bigint "plan_id"
    t.bigint "feature_id"
    t.string "value", limit: 20
    t.index ["feature_id"], name: "index_plan_features_on_feature_id"
    t.index ["plan_id"], name: "index_plan_features_on_plan_id"
  end

  create_table "plans", force: :cascade do |t|
    t.string "name"
    t.decimal "amount_per_month"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_plans_on_name"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.text "configuration"
    t.boolean "ready", default: false
    t.boolean "status", default: true
    t.bigint "user_id"
    t.bigint "space_id"
    t.integer "user_owner_id"
    t.string "repo_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_projects_on_name"
    t.index ["space_id"], name: "index_projects_on_space_id"
    t.index ["user_id"], name: "index_projects_on_user_id"
    t.index ["user_owner_id"], name: "index_projects_on_user_owner_id"
  end

  create_table "spaces", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "user_id"
    t.integer "user_owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_spaces_on_name"
    t.index ["user_id"], name: "index_spaces_on_user_id"
    t.index ["user_owner_id"], name: "index_spaces_on_user_owner_id"
  end

  create_table "teams", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "user_team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_teams_on_user_id"
    t.index ["user_team_id"], name: "index_teams_on_user_team_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", limit: 25
    t.string "first_name", limit: 25
    t.string "last_name", limit: 35
    t.text "address"
    t.string "country_code", limit: 3
    t.string "phone", limit: 15
    t.boolean "status", default: true
    t.boolean "receive_notif_last_new", default: true
    t.string "passwd"
    t.string "passwd_salt"
    t.string "auth_token"
    t.string "provider"
    t.string "uid"
    t.bigint "plan_id"
    t.bigint "api_key_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["api_key_id"], name: "index_users_on_api_key_id"
    t.index ["plan_id"], name: "index_users_on_plan_id"
    t.index ["status"], name: "index_users_on_status"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "verify_clients", force: :cascade do |t|
    t.string "token"
    t.string "data"
    t.string "concept"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["concept"], name: "index_verify_clients_on_concept"
    t.index ["token"], name: "index_verify_clients_on_token"
    t.index ["user_id"], name: "index_verify_clients_on_user_id"
  end

end
