class Animation < ActiveRecord::Base
	belongs_to :room
	has_many :frames

	def current_frame
		create_next_frame if frames.empty?
		frames.last
	end

	def complete?
		frames.size == number_of_frames and current_frame.expired?
	end

	private

	def create_next_frame
		unless complete?
			frames.create
			schedule_frame_completion
		end
	end

	def schedule_frame_completion
		Rufus::Scheduler.singleton.in "#{timer_per_frame}s" do
			# Store the current canvas image into S3
			canvas = Canvas.new room.id
			svg = canvas.get

			# Clear the current canvas from redis
			canvas.clear

			if complete?
				# Render the animation over AWS Lambda
			else
				create_next_frame
			end
		end
	end
end
