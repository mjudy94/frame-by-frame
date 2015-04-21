module PasswordHelper
  def form_password
    hidden_field_tag :p, params[:p]
  end
end
