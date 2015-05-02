class Gallery < ActiveRecord::Base
	belongs_to :room
	has_many :videos


	def is_public
		#need to make is_public an attribute of room in order to implement this
	end

	def name 
		return self.room.name
	end

end
