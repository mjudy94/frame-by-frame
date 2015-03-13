class RoomsController < ApplicationController
  def initialize
    @error = "Could not find the specified room. Try going to http://localhost:3000/rooms/public/edit"
  end

  def new
  end

  def edit
    render plain: @error if params[:id] != "public"
  end
end
