class GalleriesController < ApplicationController
	before_destroy :warning_message

	def index
		@galleries = Gallery.all
	end

	def create
		@gallery = Gallery.new(gallery_params)
	end

	def show
		@gallery = Gallery.find_by_id(params[:id])
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

		end

		def warning_message

		end

end
