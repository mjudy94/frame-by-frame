TIMER_UNITS = [["seconds", "1"], ["minutes", "60"]]

class AnimationsController < ApplicationController
  def new
    @animation = Animation.new
  end
end
