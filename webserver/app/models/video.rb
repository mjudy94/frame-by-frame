class Video < ActiveRecord::Base
	belongs_to :gallery

	@@s3 = Aws::S3::Resource.new(
		region: 'us-east-1',
		access_key_id: Rails.configuration.s3_access_key_id,
		secret_access_key: Rails.configuration.s3_secret_access_key
	)

	def presigned_url
		@@s3.bucket(Rails.configuration.s3_bucket)
			.object(video_url)
			.presigned_url(:get, expires_in: 1800)
	end
end
