class Frame < ActiveRecord::Base
	belongs_to :animation

	def expiration_date
		created_at + animation.timer_per_frame.seconds
	end

	def expired?
		expiration_date < Time.now
	end
end
