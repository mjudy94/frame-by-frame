class VideosController < ApplicationController

	include Password

  password do
    id = params[:room_id]
    Room.find(id).password if id and id != 'public'
  end

	def create
		@video = @video.new(video_params)
	end

	def show
		@video = Video.find(params[:id])
		@gallery = @video.gallery
	end

	def destroy
		@video = Video.find(params[:id])
		@video.destroy
	end

	private

		def video_params
			p = params.require(:video).permit(:video_url, :name)
		end

end
