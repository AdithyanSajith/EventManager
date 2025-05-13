class TicketsController < ApplicationController
  before_action :authenticate_participant!

  def show
    @registration = current_participant.registrations.find(params[:id])
    @ticket = @registration.ticket
  end
end
