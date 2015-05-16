# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Public room and animation
if not Room.any?
  publicVideo = Video.create video_url: 'galleries/1/elephants-dream.webm', name: 'elephants-dream.webm'
  publicGallery = Gallery.create
  publicGallery.videos << publicVideo
  publicRoom = Room.create name: 'Public Room'
  publicRoom.gallery = publicGallery
  publicGallery.room = publicRoom
  publicRoom.create_animation
end
