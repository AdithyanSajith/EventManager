class TicketsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_participant!

  def show
    @ticket = Ticket.find(params[:id])
    @registration = @ticket.registration

    # Ensure the ticket belongs to the logged-in participant
    if @registration.participant_id != current_user.id
      redirect_to filtered_events_path, alert: "You are not authorized to view this ticket."
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to filtered_events_path, alert: "Ticket not found."
  end

  private

  def ensure_participant!
    unless current_user.role == "participant"
      redirect_to root_path, alert: "Only participants can access tickets."
    end
  end
end
