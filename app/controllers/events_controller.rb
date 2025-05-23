class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :authorize_host!, only: [:new, :create, :edit, :update, :destroy, :index, :other_events]
  before_action :authorize_participant!, only: [:filtered]

  # Show only current host's events
  def index
    @events = current_user.userable.events.includes(:venue, :category)
  end

  # Form to create new event
  def new
    @event = Event.new
  end

  # Handle creation logic
  def create
    @event = current_user.userable.events.build(event_params)
    if @event.save
      redirect_to @event, notice: "Event was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # View event details with logic per role
  def show
    if current_user.role == "participant"
      @registration = current_user.registrations.find_by(event_id: @event.id)
      @payment = @registration&.payment
      @ticket = @registration&.ticket

    elsif current_user.role == "host"
      if current_user.userable == @event.host
        @registrations = @event.registrations.includes(:user)
      else
        # View-only for other hosts
      end
    else
      redirect_to root_path, alert: "You are not authorized to view this event."
    end
  end

  # Show events matching participant's interest
  def filtered
    @events = Event.where(category_id: current_user.interest)
  end

  # Show events not created by current host
  def other_events
    @events = Event.where.not(host_id: current_user.userable.id)
  end

  # Edit form
  def edit
    unless current_user.userable == @event.host
      redirect_to events_path, alert: "You can only edit your own events."
    end
  end

  # Update logic
  def update
    if current_user.userable == @event.host
      if @event.update(event_params)
        redirect_to @event, notice: "Event was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    else
      redirect_to events_path, alert: "You can only update your own events."
    end
  end

  # Delete event
  def destroy
    if current_user.userable == @event.host
      @event.destroy
      redirect_to events_path, notice: "Event deleted successfully."
    else
      redirect_to events_path, alert: "You are not authorized to delete this event."
    end
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :description, :starts_at, :ends_at, :category_id, :venue_id)
  end

  def authorize_host!
    unless current_user.role == "host" && current_user.userable_type == "Host"
      redirect_to root_path, alert: "Only hosts can access this page."
    end
  end

  def authorize_participant!
    redirect_to root_path, alert: "Only participants can access this section." unless current_user.role == "participant"
  end
end
