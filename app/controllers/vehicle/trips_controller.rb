class Vehicle::TripsController < AuthenticatedController
  before_filter :ensure_valid_vehicle!

  def index
    pagination_params = {
      :page    => params.fetch(:page, 1),
      :limit   => params.fetch(:limit, 25),
      :vehicle => params[:vehicle_id]
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

  private
  def vehicle
    return @vehicle if @vehicle

    vehicle_model = nil

    vehicle_route = Automatic::Client.routes.route_for('vehicle')
    vehicle_url   = vehicle_route.url_for(id: params[:vehicle_id])

    vehicle_request = Automatic::Client.get(vehicle_url)

    vehicle_request.on(:success) do |resp|
      vehicle_model = Automatic::Models::Vehicle.new(resp.body)
    end

    @vehicle = vehicle_model
  end
  helper_method :vehicle

  def vehicle?
    !vehicle.nil?
  end

  def ensure_valid_vehicle!
    render_404 unless vehicle?
  end
end
