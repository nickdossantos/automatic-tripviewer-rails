class VehiclesController < ApplicationController
  before_filter :verify_access_token!

  def index
    pagination_params = {
      :page  => params.fetch(:page, 1),
      :limit => params.fetch(:limit, 25)
    }

    vehicles_route   = automatic_routes.route_for('vehicles')
    vehicles_request = automatic_connection.get(vehicles_route.url_for, pagination_params)

    case(vehicles_request.status)
    when 200
      vehicles_response = MultiJson.load(vehicles_request.body)
      link_header_data  = vehicles_request.headers['link']
      link_header       = Automatic::Response::LinkHeader.new(link_header_data)
      metadata          = Automatic::Response::Metadata.new(vehicles_response.fetch('_metadata', {}))
      pagination        = Automatic::Response::Pagination.new(pagination_params.merge!(total_entries: metadata.count))
      trips             = Automatic::Models::Trips.new(vehicles_response.fetch('results', []))
      vehicles_data     = vehicles_response.fetch('results', [])

      trip_request_params = {
        :limit => pagination_params[:limit]
      }

      trips_route   = automatic_routes.route_for('trips')
      trips         = all_trips(trips_route.url_for, trip_request_params)
      grouped_trips = trips.group_by { |record| record['vehicle'] }

      vehicles_data.each do |vehicle_data|
        vehicle_data.merge!('trips' => grouped_trips[vehicle_data['url']])
      end

      @vehicles = Automatic::Models::Vehicles.new(vehicles_data)
    else
      render_500
    end
  end
end
