class Animation < ActiveRecord::Base
	belongs_to :room
	has_many :frames

	def current_frame
		frames.create if frames.empty?
		frames.last
	end

	def complete?
		frames.size == number_of_frames and current_frame.expired?
	end
end
