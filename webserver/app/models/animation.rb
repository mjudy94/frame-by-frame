class Animation < ActiveRecord::Base
	belongs_to :room
	has_many :frames

	def current_frame
		create_next_frame if frames.empty? || (frames.last.expired? && !complete?)
		frames.last
	end

	def complete?
		frames.size == number_of_frames and frames.last.expired?
	end

	def frames_remaining
		number_of_frames - frames.size
	end

	private

	def create_next_frame
		frames.create
		schedule_frame_completion
	end

	def schedule_frame_completion
		Rufus::Scheduler.singleton.in "#{timer_per_frame}s" do
			canvas = Canvas.new room.id

			# Store the current canvas image into S3
			svg = canvas.get

			# Clear the current canvas from redis
			canvas.clear

			if complete?
				# Render the animation over AWS Lambda
			end
		end
	end
end
