class AuthenticatedController < ApplicationController
  before_filter :verify_access_token!
  before_filter :configure_client

  private
  def configure_client
    Automatic::Client.configure do |c|
      c.access_token = access_token
    end
  end

  def current_user
    return @current_user if @current_user

    user_model = nil

    user_route = Automatic::Client.routes.route_for('user')
    user_url   = user_route.url_for(id: session[:automatic_sid])

    user_request = Automatic::Client.get(user_url)

    user_request.on(:success) do |resp|
      user_data  = resp.body
      user_model = Automatic::Models::User.new(user_data)
    end

    @current_user = user_model
  end
  helper_method :current_user

  def current_user?
    current_user.present?
  end
  helper_method :current_user?
end
