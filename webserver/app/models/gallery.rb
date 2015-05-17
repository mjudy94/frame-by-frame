class Gallery < ActiveRecord::Base
	belongs_to :room
	has_many :videos

	def is_public
		if self.room.password == nil
			is_public = true
		else
			is_public = false
		end
		return is_public
	end

	def self.public_galleries
		Room.where(password: nil).map do |room|
			room.gallery
		end
	end

	def name
		return room.name
	end

end
