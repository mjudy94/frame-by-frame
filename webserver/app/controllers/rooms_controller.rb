class RoomsController < ApplicationController

  before_action :authenticate, only: [:show, :edit]

  def index
    @rooms = Room.all
  end

  def new
  end

  def create
    @room = Room.new(room_params)

    @room.save
    redirect_to @room
  end

  def edit
  end

  def show
    if params[:id] == "public"
      @room = Room.find(1)
    else
      @room = Room.find(params[:id])
    end
  end

  private

    def authenticate
      if params[:id] != "public"
        authenticate_or_request_with_http_basic do |username, password|
          @username = username
          password == Room.find(params[:id]).password
        end
      end
    end

    def room_params
      params.require(:room).permit(:name, :password)
    end
end
