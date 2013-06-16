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

ActiveRecord::Schema.define(:version => 20130616132228) do

  create_table "feed_items", :force => true do |t|
    t.integer "user_id"
    t.integer "doc_id"
    t.string "doc_type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "feed_items", ["user_id", "updated_at"], :name => "index_feed_items_on_user_id_and_updated_at"

  create_table "likes", :force => true do |t|
    t.integer "doc_id"
    t.string "doc_type"
    t.integer "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "likes", ["doc_id", "doc_type"], :name => "index_likes_on_doc_id_and_doc_type"
  add_index "likes", ["user_id"], :name => "index_likes_on_user_id"

  create_table "messages", :force => true do |t|
    t.integer "sender_id"
    t.integer "recipient_id"
    t.boolean "sender_deleted", :default => false
    t.boolean "recipient_deleted", :default => false
    t.string "subject"
    t.text "body"
    t.datetime "read_at"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "posts", :force => true do |t|
    t.string "content"
    t.integer "feed_item_id"
    t.integer "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "posts", ["feed_item_id"], :name => "index_posts_on_feed_item_id", :unique => true

  create_table "relationships", :force => true do |t|
    t.string "follower_id"
    t.string "followed_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sermons", :force => true do |t|
    t.string "title"
    t.string "subtitle"
    t.string "content"
    t.string "user_id"
    t.datetime "day"
    t.string "type_of_liturgy"
    t.string "audio"
    t.string "video"
    t.string "feed_item_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sermons", ["feed_item_id"], :name => "index_sermons_on_feed_item_id", :unique => true

  create_table "users", :force => true do |t|
    t.string "name"
    t.string "surname"
    t.string "honorific"
    t.string "email"
    t.date "birth"
    t.date "orderDay"
    t.string "study"
    t.string "role"
    t.string "placeForRole"
    t.string "diocese"
    t.string "institute"
    t.string "interests"
    t.string "aboutMe"
    t.boolean "confirmed"
    t.string "remember_token"
    t.string "password_digest"
    t.boolean "admin", :default => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["id"], :name => "index_users_on_id", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
