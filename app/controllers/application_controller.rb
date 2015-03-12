require File.expand_path('lib/automatic', Rails.root)

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private
  def access_token
    if session[:automatic_credentials]
      session[:automatic_credentials]['token']
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

  def automatic_routes
    @automatic_routes || Automatic.routes
  end

  def automatic_connection
    return @connection if @connection

    @connection = Faraday.new(url: ENV.fetch('AUTOMATIC_API_HOST')) do |conn|
      conn.use(:gzip)
      conn.response(:logger, http_request_logger)
      conn.adapter(Faraday.default_adapter)
    end

    @connection.headers['Authorization']   = ("Bearer %s" % [access_token])
    @connection.headers['User-Agent']      = 'TripViewer/Rails'
    @connection.headers['Accept']          = 'application/json'
    @connection.headers['Accept-Encoding'] = 'gzip,deflate'

    @connection
  end

  def automatic_user
    return @automatic_user if @automatic_user

    user_route   = automatic_routes.route_for('user')
    user_request = automatic_connection.get(user_route.url_for(id: session[:automatic_sid]))

    @automatic_user = OpenStruct.new(MultiJson.load(user_request.body))
  end
  helper_method :automatic_user

  def http_request_logger
    @http_request_logger ||= Logger.new(File.expand_path('log/requests.log', Rails.root))
  end

  def render_404
    render file: "#{Rails.root}/public/404.html", layout: false, status: 404
  end

  def render_500
    render file: "#{Rails.root}/public/500.html", layout: false,  status: 500
  end

  # This is a placeholder to retrieve all trips and then
  # expand the corresponding `user` and `vehicle` fields.
  #
  # This will be used for the downloading, as well as for summary views
  def all_trips(uri, options={})
    paginate = if options.has_key?(:paginate)
      options.delete(:paginate)
    else
      true
    end

    all_trips     = []

    trips_request = automatic_connection.get(uri, options)

    case(trips_request.status)
    when 200
      trips_response   = MultiJson.load(trips_request.body)
      link_header_data = trips_request.headers['link']
      link_header      = Automatic::Response::LinkHeader.new(link_header_data)
      links            = link_header.links

      all_trips.concat(trips_response.fetch('results', []))

      if links.next? && paginate
        loop do
          next_link_href = links.next.uri

          trips_request = automatic_connection.get(next_link_href)

          case(trips_request.status)
          when 200
            trips_response   = MultiJson.load(trips_request.body)
            link_header_data = trips_request.headers['link']
            link_header      = Automatic::Response::LinkHeader.new(link_header_data)
            links            = link_header.links

            all_trips.concat(trips_response.fetch('results', []))

            #break if true
            break unless links.next?
          end
        end
      end
    end
    all_trips
  end
end
