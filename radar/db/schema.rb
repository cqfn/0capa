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

ActiveRecord::Schema.define(version: 2021_11_12_132325) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "tom_analyses", force: :cascade do |t|
    t.string "extractor_id"
    t.string "repo_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tom_analysis_metrics", force: :cascade do |t|
    t.string "analysis_id"
    t.string "metric_name"
    t.string "value"
    t.string "is_best_value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tom_projects", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "isactive"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tom_push_infos", force: :cascade do |t|
    t.string "head_commit_id"
    t.string "full_name"
    t.string "isFork"
    t.integer "open_issues_count"
    t.string "size"
    t.string "language"
    t.integer "commits_count"
    t.integer "total_files_added"
    t.integer "total_files_removed"
    t.integer "total_files_changed"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "repo_name"
    t.string "repo_url"
    t.string "status", default: "P"
  end

  create_table "tom_radar_activations", force: :cascade do |t|
    t.string "source"
    t.string "issuetitle"
    t.string "issuebody"
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.json "request_body"
  end

  create_table "tom_settings", force: :cascade do |t|
    t.string "agentname"
    t.string "accesstokenendpoint"
    t.string "authorizationbaseurl"
    t.string "requesttokenendpoint"
    t.string "authenticationmethod"
    t.string "apikey"
    t.string "apisecret"
    t.string "isactive"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
