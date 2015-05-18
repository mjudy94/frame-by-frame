class UserMailer < ApplicationMailer
  def server_email(to, from , url)
  	@url = url
    mail(:to => to, :from => from, :subject => "a Frame-by-Frame room has shared with you")
  end
end
