class AnimationsController < ApplicationController
  DEFAULT_NUMBER_OF_FRAMES = 60
  DEFAULT_TIMER_PER_FRAME = 30
  DEFAULT_VIDEO_FRAME_RATE = 15
  TIMER_UNITS = [["seconds", "1"], ["minutes", "60"]]

  def new
    @animation = Animation.new
  end
end
