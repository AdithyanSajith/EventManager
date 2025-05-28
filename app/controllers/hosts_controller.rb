class HostsController < ApplicationController
  before_action :authenticate_resource_owner!
  before_action :ensure_host!

  def dashboard
    # Show only events created by this host
    @events = current_resource_owner.userable.events.includes(:venue, :category)
  end

  private

  def authenticate_resource_owner!
    if doorkeeper_token
      doorkeeper_authorize!
    else
      authenticate_user!
    end
  end

  def current_resource_owner
    if doorkeeper_token
      User.find(doorkeeper_token.resource_owner_id)
    else
      current_user
    end
  end
  helper_method :current_resource_owner

  def ensure_host!
    unless current_resource_owner&.role == "host" && 
           current_resource_owner.userable_type == "Host" && 
           current_resource_owner.userable.present?
      redirect_to root_path, alert: "Access denied. You must be a host to view this page."
    end
  end
end
