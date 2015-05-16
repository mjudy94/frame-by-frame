module RoomsHelper
  def frame_progress
    "Frame #{@room.animation.frames.size}/#{@room.animation.number_of_frames}"
  end
end
