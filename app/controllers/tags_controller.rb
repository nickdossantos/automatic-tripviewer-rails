class TagsController < ApplicationController
  def create
    if trip
      tag_params  = params.require(:trip).permit(:is_business)
      is_business = tag_params[:is_business]

      # Toggle and create or delete
      case(is_business)
      when 'false', false
        trip_tag_route = Automatic::Client.routes.route_for('tag-detail-trip')
        trip_tag_url   = trip_tag_route.url_for(id: trip.id, slug: 'business')

        trip_tag_request = Automatic::Client.delete(trip_tag_url)

        trip_tag_request.on(:success) do |resp|
          respond_to do |wants|
            wants.html do
              redirect_to(trip_path(trip.id)) and return
            end
            wants.json do
              response_body = {
                :status => resp.status
              }
              render(json: MultiJson.dump({}), status: 200)
            end
          end
        end

        trip_tag_request.on(:failure, :server_error) do |resp|
          respond_to do |wants|
            wants.html do
              redirect_to(trip_path(trip.id)) and return
            end
            wants.json do
              response_body = {
                :status => resp.status
              }
              render(json: MultiJson.dump({}), status: 200)
            end
          end
        end
      when 'true', true
        trip_tag_route = Automatic::Client.routes.route_for('tag-trip')
        trip_tag_url   = trip_tag_route.url_for(id: trip.id)

        trip_tag_request = Automatic::Client.post(trip_tag_url, MultiJson.dump(tag: 'business'))

        trip_tag_request.on(:success) do |resp|
          respond_to do |wants|
            wants.html do
              redirect_to(trip_path(trip.id)) and return
            end
            wants.json do
              response_body = {
                :status => resp.status
              }
              render(json: MultiJson.dump({}), status: 200)
            end
          end
        end

        trip_tag_request.on(:failure, :server_error) do |resp|
          respond_to do |wants|
            wants.html do
              redirect_to(trip_path(trip.id)) and return
            end
            wants.json do
              response_body = {
                :status => resp.status
              }
              render(json: MultiJson.dump({}), status: 200)
            end
          end
        end
      end
    else
      render_404
    end
  end

  private
  def trip
    return @trip if @trip

    trip_model = nil

    trip_route = Automatic::Client.routes.route_for('trip')
    trip_url   = trip_route.url_for(id: params[:trip_id])

    trip_request = Automatic::Client.get(trip_url)

    trip_request.on(:success) do |resp|
      trip_model = Automatic::Models::Trip.new(resp.body)
    end

    @trip = trip_model
  end
end
