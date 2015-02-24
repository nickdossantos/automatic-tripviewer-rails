class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private
  def access_token
    ENV['AUTOMATIC_ACCESS_TOKEN']
  end
  helper_method :access_token

  def access_token?
    access_token.present?
  end
  helper_method :access_token?
end
