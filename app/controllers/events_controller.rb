class EventsController < ApplicationController
  before_action :authenticate_host!, only: [:new, :create, :edit, :update, :destroy, :index]
  before_action :authenticate_participant!, only: [:filtered, :show]
  before_action :set_event, only: [:show, :edit, :update]
  
  def index
    @events = current_host.events # 🔐 Only events created by this host
  end

  def new
    @event = Event.new
  end

  def create
    @event = current_host.events.build(event_params)
    if @event.save
      redirect_to @event, notice: "Event was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    # @event is already set in before_action

    if participant_signed_in?
      @registration = current_participant.registrations.find_by(event: @event)
      @payment = @registration&.payment
      @ticket = @registration&.ticket
    elsif host_signed_in? && current_host == @event.host
      @registrations = @event.registrations.includes(:participant)
    else
      redirect_to root_path, alert: "You are not authorized to view this event."
    end
  end

  def filtered
    @events = Event.where(category_id: current_participant.interest)
  end

  def edit
    unless current_host == @event.host
      redirect_to events_path, alert: "You can only edit your own events."
    end
  end

  def update
    if current_host == @event.host
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
    event = current_host.events.find_by(id: params[:id])
    if event
      event.destroy
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
end
