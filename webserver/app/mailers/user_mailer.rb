class UserMailer < ApplicationMailer
  def server_email(to, from , url)
  	@url = url
    mail(:to => to, :from => from, :subject => "Hello World!")
  end
end
