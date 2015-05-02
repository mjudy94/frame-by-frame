class EmailController < ApplicationController
  def new
  end

  def create
  	user_entry = params[:q]
  	current_url = params[:current_room_url]
    UserMailer.server_email(user_entry, current_url).deliver
    redirect_to current_url
  end
end
