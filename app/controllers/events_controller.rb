class EventsController < ApplicationController
  before_action :authenticate_resource_owner!, except: [:show]
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :authorize_host!, only: [:new, :create, :edit, :update, :destroy, :index, :other_events]
  before_action :authorize_participant!, only: [:filtered]

  def index
    @events = current_resource_owner.userable.events.includes(:venue, :category)
  end

  def new
    @event = Event.new
  end
  # Error 422 Unprocessable Enitity
  def create
    @event = current_resource_owner.userable.events.build(event_params)
    if @event.save
      redirect_to @event, notice: "Event was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @event = Event.find(params[:id])
    # Allow anyone to view event details, but only show registration/payment/ticket if logged in and authorized
    if user_signed_in?
      if current_resource_owner.role == "participant"
        @registration = current_resource_owner.userable.registrations.find_by(event_id: @event.id)
        @payment = @registration&.payment
        @ticket = @registration&.ticket
      elsif current_resource_owner.role == "host" && current_resource_owner.userable == @event.host
        @registrations = @event.registrations.includes(:user)
      end
    end
    # Render show view for all users (even if not logged in)
  end

  def filtered
    @events = Event.where(category_id: current_resource_owner.interest).includes(:venue, :reviews)
  end

  def other_events
    @events = Event.where.not(host_id: current_resource_owner.userable.id)
  end

  def edit
    redirect_to events_path, alert: "You can only edit your own events." unless current_resource_owner.userable == @event.host
  end

  def update
    if current_resource_owner.userable == @event.host
      if @event.update(event_params)
        redirect_to @event, notice: "Event was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    else
      redirect_to events_path, alert: "You can only update your own events."
    end
  end

  def destroy
    if current_resource_owner.userable == @event.host
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
    unless current_resource_owner&.role == "host" && current_resource_owner&.userable_type == "Host"
      redirect_to root_path, alert: "Only hosts can access this page."
    end
  end

  def authorize_participant!
    redirect_to root_path, alert: "Only participants can access this section." unless current_resource_owner&.role == "participant"
  end
end
