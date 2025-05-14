class EventsController < ApplicationController
  before_action :set_event, only: %i[show edit update destroy]
  before_action :authenticate_participant!, only: [:show]

  def show
  @event = Event.find(params[:id])

  if participant_signed_in?
    @registration = current_participant.registrations.find_by(event: @event)
    @payment = @registration&.payment
    @ticket = @registration&.ticket
  elsif host_signed_in?
    @registrations = @event.registrations.includes(:participant)
  end
end



  def index
    @events = Event.all
  end

  def new
    @event = Event.new
  end

  def filtered
    @events = Event.where(category_id: current_participant.interest)
  end

  def create
    @event = current_host.events.build(event_params)
    if @event.save
      redirect_to @event, notice: "Event was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @event.update(event_params)
      redirect_to @event, notice: "Event was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    puts "HOST ID: #{current_host&.id}"  # ✅ move this inside the method

    if host_signed_in?
      @event = current_host.events.find_by(id: params[:id])
      if @event
        @event.destroy
        redirect_to events_path, notice: "Event deleted successfully."
      else
        redirect_to events_path, alert: "You are not authorized to delete this event."
      end
    else
      redirect_to root_path, alert: "You must be logged in as a host to delete events."
    end
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :description, :starts_at, :ends_at, :category_id, :venue_id)
  end
end
