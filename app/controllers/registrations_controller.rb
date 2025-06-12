class RegistrationsController < ApplicationController #handle event registrations
  before_action :authenticate_resource_owner! # Ensure user is authenticated
  before_action :ensure_participant! # Ensure the user is a participant

  # Use the application layout for this controller
  layout "application"
  before_action :set_event, only: [:new, :create]
  before_action :set_registration, only: [:show]

  def index
    if params[:event_id]
      @event = Event.find(params[:event_id])
      @registrations = @event.registrations.includes(:participant, :ticket, :payment)
    else
      @registrations = Registration.all
    end
  end

  def show
    # @registration is set by before_action
  end

  def new
    @registration = Registration.new
  end

  def create
    # Only allow participants to register
    unless current_resource_owner.userable_type == "Participant"
      render_flash_message(:error, "Only participants can register for events.")
      redirect_to events_path
      return
    end

    # Check if the user is already registered
    existing_registration = @event.registrations.find_by(participant_id: current_resource_owner.userable&.id)
    if existing_registration
      render_flash_message(:info, "You are already registered for this event.")
      redirect_to new_event_payment_path(@event)
      return
    end

    # TODO: Add event open/registration full checks here if needed
    # if @event.full? || !@event.registration_open?
    #   render_flash_message(:error, "Registration is closed or event is full.")
    #   redirect_to event_path(@event)
    #   return
    # end

    @registration = @event.registrations.new(participant_id: current_resource_owner.userable&.id)

    if @registration.save
      render_flash_message(:success, "You have successfully registered for this event!")
      set_single_snackbar(:registration, action: :success, details: "Registration successful! Please complete payment to receive your ticket.")
      redirect_to new_event_payment_path(@event)
    else
      render_flash_message(:error, "Registration failed.")
      @snackbar_js = registration_snackbar(:error, @registration.errors.full_messages.to_sentence)
      render :new
    end
  end

  private

  def set_event
    @event = Event.find(params[:event_id]) if params[:event_id].present?
  end

  def set_registration
    @registration = Registration.find(params[:id])
  end
end