class TripsController < AuthenticatedController

  def index
    pagination_params = {
      :page  => params.fetch(:page, 1),
      :limit => params.fetch(:limit, 25)
    }

    trips_route = Automatic::Client.routes.route_for('trips')
    trips_url   = trips_route.url_for(pagination_params)

    trips_request = Automatic::Client.get(trips_url)

    trips_request.on(:success) do |resp|
      metadata = Automatic::Models::Response::Metadata.new(resp.body.fetch('_metadata', {}))
      trips    = Automatic::Models::Trips.new(resp.body.fetch('results', []))

      @trips      = trips
      @pagination = Pagination.new(pagination_params.merge!(total_entries: metadata.count))
    end

    trips_request.on(:server_error) do |resp|
      render_500
    end
  end

  def show
    trip_route = Automatic::Client.routes.route_for('trip')
    trip_url   = trip_route.url_for(id: params[:id])

    trip_request = Automatic::Client.get(trip_url)

    trip_request.on(:success) do |resp|
      @trip = Automatic::Models::Trip.new(resp.body)
    end

    trip_request.on(404) do |resp|
      render_404
    end

    trip_request.on(:server_error) do |resp|
      render_500
    end
  end
end
