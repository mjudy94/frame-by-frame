class RoomsController < ApplicationController
  include Password

  password do
    id = params[:id]
    Room.find(id).password if id and id != 'public'
  end

  def index
    @rooms = Room.all
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)

    if @room.save
      @room.create_gallery
      redirect_with_password @room, p: @room.password
    else
      render :new
    end
  end

  def edit
    render_access_forbidden and return if is_global_room
    @room = Room.find(params[:id])
  end

  def update
    render_access_forbidden and return if is_global_room
    @room = Room.find(params[:id])

    if @room.update(room_params)
      redirect_with_password @room
    else
      redirect_with_password @room, :action => :edit
    end
  end

  def show
    if params[:id] == 'public'
      @room = Room.find(1)
    else
      @room = Room.find(params[:id])
    end

    # Send attributes to JS
    gon.push(
      frame_expiration: @room.animation ? @room.animation.current_frame.expiration : nil,
      animation_complete: @room.animation ? @room.animation.complete? : nil,
      number_of_frames: @room.animation ? @room.animation.number_of_frames : nil,
      room_id: @room.id,
      password: @room.password,
      faye_url: Rails.configuration.faye_url,
      current_frame_url: url_with_password([@room, :animation], action: :current_frame),
      last_frame_url: url_with_password([@room, :animation], action: :last_frames)
    )
  end

  private

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

  def render_access_forbidden
    render plain: 'Access forbidden', status: :forbidden
  end

  def is_global_room
    id = params[:id]
    id == 'public' || id == 1
  end
end
