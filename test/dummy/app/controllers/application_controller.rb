class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user

  protected

  def current_user
    'awesome_user'
  end
end
