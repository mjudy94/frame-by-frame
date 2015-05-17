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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150516031746) do

  create_table "animations", force: true do |t|
    t.integer  "number_of_frames"
    t.integer  "timer_per_frame"
    t.integer  "video_framerate"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "room_id"
  end

  add_index "animations", ["room_id"], name: "index_animations_on_room_id"

  create_table "frames", force: true do |t|
    t.string   "image_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "animation_id"
  end

  add_index "frames", ["animation_id"], name: "index_frames_on_animation_id"

  create_table "galleries", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "room_id"
  end

  add_index "galleries", ["room_id"], name: "index_galleries_on_room_id"

  create_table "rooms", force: true do |t|
    t.string   "name"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "videos", force: true do |t|
    t.string   "video_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "gallery_id"
    t.string   "name"
  end

  add_index "videos", ["gallery_id"], name: "index_videos_on_gallery_id"

end
