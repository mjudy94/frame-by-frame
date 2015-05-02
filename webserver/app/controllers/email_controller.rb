class EmailController < ApplicationController
  def create
    from = params.require(:from)
    params.require(:to).each do |to|
      UserMailer.server_email(to, from, request.referrer).deliver
    end
    redirect_to request.referrer
  end
end
