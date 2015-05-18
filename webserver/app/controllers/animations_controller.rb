class AnimationsController < ApplicationController
  DEFAULT_NUMBER_OF_FRAMES = 60
  DEFAULT_TIMER_PER_FRAME = 30
  DEFAULT_VIDEO_FRAME_RATE = 15
  TIMER_UNITS = [['seconds'], ['minutes']]

  include Password

  password do
    id = params[:room_id]
    Room.find(id).password if id && id != 'public'
  end

  def new
    room = Room.find params[:room_id]
    @animation = room.build_animation
  end

  def create
    room = Room.find params[:room_id]
    @animation = room.build_animation animation_params
    if @animation.save
      redirect_with_password room
    else
      render :new
    end
  end

  private

  def animation_params
    p = params.require(:animation).permit(
      :number_of_frames,
      :timer_per_frame,
      :video_framerate
    )
    p[:timer_per_frame] = p[:timer_per_frame].to_i * 60 if params[:timer_units] == 'minutes'
    return p
  end
end
