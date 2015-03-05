require 'restless_router'

require File.expand_path('../automatic/models.rb', __FILE__)
require File.expand_path('../automatic/response.rb', __FILE__)
require File.expand_path('../automatic/utilities.rb', __FILE__)

module Automatic
  def self.routes
    return @routes if @routes

    @routes = RestlessRouter::Routes.new
    @routes.add_route(RestlessRouter::Route.new('trips', 'https://api.automatic.com/trip/{?page,per_page}', templated: true))
    @routes.add_route(RestlessRouter::Route.new('trip', 'https://api.automatic.com/trip/{id}/', templated: true))
    @routes.add_route(RestlessRouter::Route.new('vehicles', 'https://api.automatic.com/vehicle/{?page,per_page}', templated: true))
    @routes.add_route(RestlessRouter::Route.new('vehicle', 'https://api.automatic.com/vehicle/{id}/', templated: true))

    @routes
  end
end
