require File.expand_path('lib/pagination', Rails.root)

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private
  def automatic_credentials
    session[:automatic_credentials]
  end

  def automatic_credentials?
    automatic_credentials.present?
  end

  def access_token
    if automatic_credentials?
      automatic_credentials['token']
    else
      ENV['AUTOMATIC_ACCESS_TOKEN']
    end
  end
  helper_method :access_token

  def access_token?
    access_token.present?
  end
  helper_method :access_token?

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

  def configure_client
    Automatic::Client.configure do |c|
      c.access_token = access_token
    end
  end

  def ensure_not_authenticated!
    redirect_to(trips_url) if access_token?
  end

  def verify_access_token!
    redirect_to(login_path) unless access_token?
  end

  def http_request_logger
    @http_request_logger ||= Logger.new(File.expand_path('log/requests.log', Rails.root))
  end

  def render_404
    render file: "#{Rails.root}/public/404.html", layout: false, status: 404
  end

  def render_500
    render file: "#{Rails.root}/public/500.html", layout: false,  status: 500
  end
end
