class PagesController < ApplicationController
  before_filter :verify_access_token!, only: [:home]

  def home
    pagination_params = {
      :limit => params.fetch(:limit, 25)
    }

    trips_route  = automatic_routes.route_for('trips')
    trip_records = all_trips(trips_route.url_for, pagination_params)

    @trips = Automatic::Models::Trips.new(trip_records)
  end

  def login
    render layout: false
  end
end
