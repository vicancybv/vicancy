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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140805181623) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,  :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "attachments", :force => true do |t|
    t.integer  "video_request_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
  end

  add_index "attachments", ["video_request_id"], :name => "index_attachments_on_video_request_id"

  create_table "clients", :force => true do |t|
    t.integer  "user_id"
    t.string   "external_id"
    t.string   "name"
    t.string   "email"
    t.string   "language"
    t.string   "slug"
    t.string   "token"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "clients", ["slug"], :name => "index_clients_on_slug", :unique => true
  add_index "clients", ["token"], :name => "index_clients_on_token", :unique => true
  add_index "clients", ["user_id", "external_id"], :name => "index_clients_on_user_id_and_external_id", :unique => true
  add_index "clients", ["user_id"], :name => "index_clients_on_user_id"

  create_table "google_sessions", :force => true do |t|
    t.string   "access_token"
    t.datetime "expires_at"
    t.string   "refresh_token"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "resellers", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "language"
    t.string   "token"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "uploaded_videos", :force => true do |t|
    t.string   "provider"
    t.integer  "video_id"
    t.string   "aasm_state"
    t.string   "provider_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "uploaded_videos", ["video_id"], :name => "index_uploaded_videos_on_video_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "language"
    t.string   "token"
  end

  add_index "users", ["token"], :name => "index_users_on_token", :unique => true

  create_table "video_edits", :force => true do |t|
    t.text     "edits"
    t.integer  "video_id"
    t.string   "user_ip"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "video_edits", ["video_id"], :name => "index_video_edits_on_video_id"

  create_table "video_requests", :force => true do |t|
    t.integer  "user_id"
    t.string   "user_ip"
    t.string   "link"
    t.text     "comment"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "videos", :force => true do |t|
    t.string   "youtube_id"
    t.string   "vimeo_id"
    t.string   "job_ad_url"
    t.string   "job_title"
    t.string   "company"
    t.string   "language"
    t.string   "title"
    t.text     "summary"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
    t.string   "place"
    t.string   "tags"
    t.string   "aasm_state"
  end

  create_table "vimeo_imports", :force => true do |t|
    t.string   "vimeo_id"
    t.string   "wistia_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
