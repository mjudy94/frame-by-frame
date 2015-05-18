module Password
  extend ActiveSupport::Concern

  module ClassMethods
    attr_accessor :pass_block
    def password &block
      self.pass_block = block
    end
  end

  included do
    before_action :authenticate#, only: [:index, :new, :create, :edit, :update, :show]
  end

  def redirect_with_password(obj, options={})
    redirect_to url_with_password(obj, options)
  end

  def url_with_password(obj, options={})
    options[:p] ||= password
    polymorphic_url obj, options
  end

  ApplicationController.helper_method :url_with_password

  private

  def password
    self.instance_exec &self.class.pass_block
  end

  def authenticate
    expected_password = password
    if expected_password and expected_password != params[:p]
      render_access_forbidden
    end
  end

  def render_access_forbidden
    render plain: 'Access forbidden', status: :forbidden
  end

end
