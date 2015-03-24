class RoomsController < ApplicationController

  before_action :authenticate, only: [:edit, :update, :show]

  def index
    @rooms = Room.all
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)

    if @room.save
      redirect_to_room :show
    else
      render :new
    end
  end

  def edit
    @room = Room.find(params[:id])
  end

  def update
    @room = Room.find(params[:id])

    if @room.update(room_params)
      redirect_to_room :show
    else
      redirect_to_room :edit
    end
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
      if params[:id] != 'public'
        expected_password = Room.find(params[:id]).password
        if expected_password && expected_password != params[:p]
          render plain: 'Invalid password', status: :forbidden
        end
      end
    end

    def room_params
      p = params.require(:room).permit(:name)

      if params[:room][:private] == '1'
        if !(@room && @room.password)
          p[:password] = SecureRandom.urlsafe_base64
        end
      else
        p[:password] = nil
      end

      return p
    end

    def redirect_to_room action
      redirect_to :controller => :rooms, :action => action, :id => @room.id, :p => @room.password
    end
end
