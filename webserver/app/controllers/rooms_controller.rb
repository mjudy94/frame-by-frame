class RoomsController < ApplicationController

  before_action :authenticate, only: [:show, :edit]

  def index
    @rooms = Room.all
  end

  def new
  end

  def create
    @room = Room.new(room_params)
    @room.password = SecureRandom.urlsafe_base64

    @room.save
    redirect_to controller: 'rooms', action: 'show', id: @room.id, p: @room.password
  end

  def edit
  end

  def show
    if params[:id] == 'public'
      @room = Room.find(1)
    else
      @room = Room.find(params[:id])
    end
  end

  private

    def authenticate
      if params[:id] != 'public' && params[:p] != Room.find(params[:id]).password
        render plain: 'Invalid password', status: :forbidden
      end
    end

    def room_params
      params.require(:room).permit(:name)
    end
end
