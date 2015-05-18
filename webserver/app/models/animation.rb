SVG_NODE = 	<<-SVG
<?xml version="1.0"?>
<svg
width="960" height="540"
version="1.1"
baseProfile="full"
xmlns="http://www.w3.org/2000/svg">
SVG

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
		frame.image_url = "frames/#{id}/#{frame.id}"

		if frame.save
			schedule_frame_completion frame.id
		end
	end

	def schedule_frame_completion frame_id
		Rufus::Scheduler.singleton.in "#{timer_per_frame}s" do
			canvas = Canvas.new room.id
			puts "Frame ID: #{frame_id}"

			# Store the current canvas image into S3
			svg = "#{SVG_NODE}#{canvas.get}</svg>"

			s3 = Aws::S3::Client.new(
				region: 'us-east-1',
				credentials: Aws::Credentials.new(Rails.configuration.s3_access_key_id, Rails.configuration.s3_secret_access_key)
			)

			s3.put_object(
				bucket: Rails.configuration.s3_bucket,
				body: svg,
				key: "frames/#{self.id}/#{frame_id.to_s}",
				content_type: "image/svg+xml"
			)

			# Clear the current canvas from redis
			canvas.clear

			if complete?
				if room.id == 1
					room.create_animation(
				    number_of_frames: 75,
				    timer_per_frame: 60,
				    video_framerate: 15
				  )
				end

				Lambduh.render self
			end
		end
	end
end
