class Video < ActiveRecord::Base
	belongs_to :gallery

	def self.s3_resource
		@s3 = Aws::S3::Resource.new(
			region: 'us-east-1',
			credentials: Aws::Credentials.new(Rails.configuration.s3_access_key_id, Rails.configuration.s3_secret_access_key)
		)
		return @s3
	end

end
