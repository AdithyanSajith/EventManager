class DashboardsController < ApplicationController
  before_action :authenticate_host!, only: [:host]
  before_action :authenticate_participant!, only: [:participant]

  def host
    # Logic for host dashboard (e.g. current_host.events)
  end

  def participant
    # Logic for participant dashboard (e.g. available events)
  end
end
