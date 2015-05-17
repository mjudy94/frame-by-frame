class GalleriesController < ApplicationController

	include Password

	password do
		id = params[:id]
		@gallery = Gallery.find(id)
		@room = Room.find(@gallery.room_id).password if id and !@gallery.is_public
	end

	def index
		@galleries = Gallery.bucket.object(Gallery.public_galleries)
	end

	def create
		@gallery = Gallery.new(gallery_params)
		@gallery.save
	end

	def show
		@gallery = Gallery.find_by_id(params[:id])
		@room = @gallery.room
	end

	def update
		@gallery = Gallery.find_by_id(params[:id])
	end

	def destroy
		@gallery = Gallery.find_by_id(params[:id])
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
