class PagesController < ApplicationController
  # This returns an overall summary of the
  # trips collection.
  def home
    render layout: false
  end

  # This starts the OAuth process. It will
  # be skipped if there is an access token
  # provided in the ENV.
  def login
    render layout: false
  end
end
