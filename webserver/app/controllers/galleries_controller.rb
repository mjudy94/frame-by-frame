class GalleriesController < ApplicationController

	include Password

	password do
		id = params[:room_id]
    Room.find(id).password if id && id != 'public'
	end

	def index
		@galleries = Gallery.all
		@public_galleries = []
		@galleries.each do |gallery|
			if gallery.is_public
				@public_galleries << gallery
			end
		end
	end

	def show
		@room = Room.find(params[:room_id])
		@gallery = @room.gallery
	end

	def update
		@gallery = Room.find(params[:room_id]).gallery
	end

	def destroy
		@gallery = Room.find(params[:room_id]).gallery
		@gallery.destroy
	end

	private

	def gallery_params
		p = params.require(:gallery).permit()

		if params[:room][:private] == '1'
			if !(@room && @room.password)
				p[:password] = SecureRandom.urlsafe_base64
			end
		else
			p[:password] = nil
		end

		return p
	end

	def render_access_forbidden
		render plain: 'Access forbidden', status: :forbidden
	end

	def is_global_room
		id = params[:id]
		id == 'public' || id == 1
	end

end
