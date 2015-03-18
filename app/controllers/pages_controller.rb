class PagesController < ApplicationController
  before_filter :verify_access_token!, only: [:home]

  def home
    pagination_params = {
      :limit    => params.fetch(:limit, 250),
      :paginate => true
    }

    trips_route  = automatic_routes.route_for('trips')
    trip_records = all_trips(trips_route.url_for, pagination_params)

    @trips = Automatic::Models::Trips.new(trip_records)
  end

  def create_session
    omniauth_params = request.env['omniauth.auth']

    session[:automatic_uid]         = omniauth_params['uid']
    session[:automatic_sid]         = omniauth_params['info']['id']
    session[:automatic_credentials] = omniauth_params['credentials']

    redirect_to(trips_url)
  end

  def login
    render layout: false
  end
end
