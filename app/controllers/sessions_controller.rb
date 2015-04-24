class SessionsController < ApplicationController
  before_filter :ensure_not_authenticated!, except: [:destroy]

  def new
    render(layout: false)
  end

  def create
    omniauth_params = request.env['omniauth.auth']

    session[:automatic_uid]         = omniauth_params['uid']
    session[:automatic_sid]         = omniauth_params['info']['id']
    session[:automatic_credentials] = omniauth_params['credentials']

    redirect_to(trips_url)
  end

  def destroy
    session.delete(:automatic_uid)
    session.delete(:automatic_sid)
    session.delete(:automatic_credentials)

    redirect_to(root_path)
  end
end
