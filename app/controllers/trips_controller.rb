class TripsController < ApplicationController
  before_filter :verify_access_token!

  def index
    pagination_params = {
      :page  => params.fetch(:page, 1),
      :limit => params.fetch(:limit, 25)
    }

    trips_route   = automatic_routes.route_for('trips')
    trips_request = automatic_connection.get(trips_route.url_for, pagination_params)

    case(trips_request.status)
    when 200
      trips_response   = MultiJson.load(trips_request.body)
      link_header_data = trips_request.headers['link']
      link_header      = Automatic::Response::LinkHeader.new(link_header_data)
      metadata         = Automatic::Response::Metadata.new(trips_response.fetch('_metadata', {}))
      pagination       = Automatic::Response::Pagination.new(pagination_params.merge!(total_entries: metadata.count))
      trips            = Automatic::Models::Trips.new(trips_response.fetch('results', []))

      @trips      = trips
      @pagination = pagination
    else
      render_500
    end
  end

  def show
    trip_route   = automatic_routes.route_for('trip')
    trip_request = automatic_connection.get(trip_route.url_for(id: params[:id]))

    case(trip_request.status)
    when 200
      trip_response = MultiJson.load(trip_request.body)

      @trip = Automatic::Models::Trip.new(trip_response)
    when 404
      render_404
    else
      render_500
    end
  end
end
