class EmailController < ApplicationController
 
  def new
 
  end

  def create
  	user_entry = params[:q]
  UserMailer.server_email(user_entry).deliver

  redirect_to "/"
end
end

 
