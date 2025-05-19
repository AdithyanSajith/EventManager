class HostsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_host!

  def dashboard
    @events = current_user.events
  end

  private

  def authorize_host!
    unless current_user.role == "host"
      redirect_to root_path, alert: "Only hosts can access this page."
    end
  end
end
