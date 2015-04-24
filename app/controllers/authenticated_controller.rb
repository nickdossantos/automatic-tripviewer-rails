class AuthenticatedController < ApplicationController
  before_filter :verify_access_token!
  before_filter :configure_client
end
