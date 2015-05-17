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
		frame = frames.create
		schedule_frame_completion frame.id
	end

	def schedule_frame_completion frame_id
		Rufus::Scheduler.singleton.in "#{timer_per_frame}s" do
			canvas = Canvas.new room.id
			puts "Frame ID: #{frame_id}"
			
			# Store the current canvas image into S3
			svg = "<svg>" << canvas.get() << "</svg>"

			s3 = Aws::S3::Client.new(
				region: 'us-east-1',
				credentials: Aws::Credentials.new(Rails.configuration.s3_access_key_id, Rails.configuration.s3_secret_access_key)
			)

			s3.put_object(
				bucket: Rails.configuration.s3_bucket,
				body: svg,
				key: "frames/#{self.id}/#{frame_id.to_s}"

			)
			# Clear the current canvas from redis
			canvas.clear

			if complete?
				# Render the animation over AWS Lambda
			end
		end
	end
end
