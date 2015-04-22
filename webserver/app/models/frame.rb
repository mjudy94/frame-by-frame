class Frame < ActiveRecord::Base
	belongs_to :animation

	def expired?
		created_at + animation.timer_per_frame.seconds < Time.now
	end
end
