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
