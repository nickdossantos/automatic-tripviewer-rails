class VehiclesController < AuthenticatedController

  def index
    pagination_params = {
      :page  => params.fetch(:page, 1),
      :limit => params.fetch(:limit, 25)
    }

    vehicles_route = Automatic::Client.routes.route_for('vehicles')
    vehicles_url   = vehicles_route.url_for(pagination_params)

    vehicles_request = Automatic::Client.get(vehicles_url)

    vehicles_request.on(:success) do |resp|
      metadata = Automatic::Models::Response::Metadata.new(resp.body.fetch('_metadata', {}))
      vehicles = Automatic::Models::Vehicles.new(resp.body.fetch('results', []))

      @vehicles   = vehicles
      @pagination = Pagination.new(pagination_params.merge!(total_entries: metadata.count))
    end

    vehicles_request.on(:server_error) do |resp|
      render_500
    end
  end
end
