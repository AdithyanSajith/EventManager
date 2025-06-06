class RegistrationsController < ApplicationController
  layout "application"
  before_action :set_event, only: [:new, :create], if: -> { params[:event_id].present? }
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
    # Check if the user is already registered
    existing_registration = @event.registrations.find_by(participant_id: current_resource_owner.userable&.id)
    
    if existing_registration
      # If already registered, redirect to payment
      render_flash_message(:info, "You are already registered for this event.")
      redirect_to new_event_payment_path(@event)
      return
    end

    @registration = @event.registrations.new(participant_id: current_resource_owner.userable&.id)

    if @registration.save
      # Standard flash message
      render_flash_message(:success, "You have successfully registered for this event!")
      
      # Store snackbar data in session to display after redirect
      session[:registration_snackbar] = { 
        action: :success, 
        details: "Registration successful! Please complete payment to receive your ticket."
      }
      
      # Redirect to payment page
      redirect_to new_event_payment_path(@event)
    else
      # Standard flash message
      render_flash_message(:error, "Registration failed.")
      
      # Immediate snackbar
      @snackbar_js = registration_snackbar(:error, @registration.errors.full_messages.to_sentence)
      
      render :new
    end
  end

  private

  def set_event
    if params[:event_id].present?
      @event = Event.find(params[:event_id])
    else
      @event = nil
    end
  end

  def set_registration
    @registration = Registration.find(params[:id])
  end
end