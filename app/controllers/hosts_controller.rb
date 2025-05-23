class HostsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_host!

  def dashboard
    # Only fetch events that belong to the current host user
    @events = current_user.userable&.events || []
  end

  private

  def ensure_host!
    unless current_user&.role == "host" && current_user&.userable_type == "Host" && current_user.userable.present?
      redirect_to root_path, alert: "Access denied. You must be a host to view this page."
    end
  end
end
