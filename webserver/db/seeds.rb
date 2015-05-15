# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Public room and animation
if not Room.any?
  publicRoom = Room.create name: 'Public Room'
  publicRoom.create_animation ({
    number_of_frames: 10,
    timer_per_frame: 30,
    video_framerate: 10
  })
end
