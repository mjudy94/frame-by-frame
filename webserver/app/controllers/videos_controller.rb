class VideosController < ApplicationController

	def create
		@video = @video.new(video_params)
	end

	def show
		@video = Video.find_by_id(params[:id])
		@gallery = @video.gallery
		@aws_video = Video.s3_resource.bucket(Rails.configuration.s3_bucket).object(@video.video_url)
		@aws_url = @aws_video.presigned_url(:get, expires_in: 1800)
	end

	def destroy
		@video = Video.find_by_id(params[:id])
		@video.destroy
	end

	private

		def video_params
			p = params.require(:video).permit(:video_url)

		end


end
