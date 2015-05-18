class AnimationsController < ApplicationController
  DEFAULT_NUMBER_OF_FRAMES = 60
  DEFAULT_TIMER_PER_FRAME = 30
  DEFAULT_VIDEO_FRAME_RATE = 15
  TIMER_UNITS = [['seconds'], ['minutes']]

  @@s3 = Aws::S3::Resource.new(
    region: 'us-east-1',
    access_key_id: Rails.configuration.s3_access_key_id,
    secret_access_key: Rails.configuration.s3_secret_access_key
  )

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

  def last_frames
    num = params[:num].to_i
    room = Room.find params[:room_id]
    animation = room.animation

    if num <= animation.frames.length - 1
      frames = animation.frames[animation.frames.length - 1 - num .. animation.frames.length - 2]

      frames = frames.map do |f|
        @@s3.bucket(Rails.configuration.s3_bucket)
          .object(f.image_url)
          .presigned_url(:get, expires_in: 1800)
      end

      respond_to do |format|
        format.json { render json: frames }
      end
    else
      respond_to do |format|
        format.json { render json: "Index out of bounds." }
      end
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
