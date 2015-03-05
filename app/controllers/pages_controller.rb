class PagesController < ApplicationController
  before_filter :verify_access_token!, only: [:home]

  def home
    trips_route  = automatic_routes.route_for('trips')
    trip_records = all_trips(trips_route.url_for)

    @trips = Automatic::Models::Trips.new(trip_records)
  end

  def login
    render layout: false
  end
end
