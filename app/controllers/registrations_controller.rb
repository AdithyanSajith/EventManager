class RegistrationsController < ApplicationController
  before_action :authenticate_participant!

  # POST /registrations
  def create
    @registration = current_participant.registrations.build(event_id: params[:event_id])

    if @registration.save
      redirect_to @registration.event, notice: "You have successfully registered."
    else
      redirect_to events_path, alert: "Registration failed."
    end
  end

  # Optional: to allow cancellation
  def destroy
    @registration = current_participant.registrations.find(params[:id])
    @registration.destroy
    redirect_to events_path, notice: "Registration canceled."
  end
end
