class Frame < ActiveRecord::Base
	belongs_to :animation

	def expiration
		created_at + animation.timer_per_frame.seconds
	end

	def expired?
		expiration < Time.now
	end
end
