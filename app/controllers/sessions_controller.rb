class SessionsController < ApplicationController
  def destroy
    session.delete(:automatic_uid)
    session.delete(:automatic_sid)
    session.delete(:automatic_credentials)

    redirect_to(root_path)
  end
end
