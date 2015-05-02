class VideosController < ApplicationController

	def create
		@video = @video.new(video_params)
	end

	def show
		@video = Video.find_by_id(params[:id])
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
