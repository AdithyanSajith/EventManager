class HostsController < ApplicationController
  before_action :doorkeeper_authorize!
  before_action :ensure_host!

  def dashboard
    # Show only events created by this host
    @events = current_resource_owner.userable.events.includes(:venue, :category)
  end

  private

  def ensure_host!
    unless current_resource_owner&.role == "host" && current_resource_owner.userable_type == "Host" && current_resource_owner.userable.present?
      redirect_to root_path, alert: "Access denied. You must be a host to view this page."
    end
  end
end
