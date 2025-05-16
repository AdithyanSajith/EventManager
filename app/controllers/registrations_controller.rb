class RegistrationsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_participant!

  def create
    @registration = current_user.registrations.build(event_id: params[:event_id])
    if @registration.save
      redirect_to @registration.event, notice: "You have successfully registered."
    else
      redirect_to events_path, alert: "Registration failed."
    end
  end

  def destroy
    @registration = current_user.registrations.find(params[:id])
    @registration.destroy
    redirect_to events_path, notice: "Registration canceled."
  end

  private

  def ensure_participant!
    redirect_to root_path, alert: "Only participants can register for events." unless current_user.role == "participant"
  end
end
