class RegistrationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [:new, :create]
  before_action :set_registration, only: [:show]

  def index
    @registrations = Registration.all
  end

  def show
    @registration = Registration.find(params[:id])
  end

  def new
    @registration = Registration.new
  end

  def create
    @registration = @event.registrations.new(participant_id: current_resource_owner.userable&.id)

    if @registration.save
      redirect_to filtered_events_path, notice: "You have successfully registered for this event!"
    else
      flash.now[:alert] = "Registration failed."
      render :new
    end
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_registration
    @registration = Registration.find(params[:id])
  end
end