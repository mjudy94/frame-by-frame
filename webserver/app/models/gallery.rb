class Gallery < ActiveRecord::Base
	belongs_to :room
	has_many :videos

	def is_public
		if self.room.password == nil
			public = true
		else
			public = false
		end
		return public
	end

	def self.public_galleries
		public_rooms = Room.where(password: nil)
		public_gallery = []
		public_rooms.each do |room|
			public_gallery << room.gallery
		end
	end

	def name
		return self.room.name
	end

end
