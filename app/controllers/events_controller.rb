class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :authorize_host!, only: [:new, :create, :edit, :update, :destroy, :index]
  before_action :authorize_participant!, only: [:filtered, :show]

  def index
    # Only show events hosted by current user
    @events = current_user.events.includes(:venue, :category)
  end

  def new
    @event = Event.new
  end

  def create
    @event = current_user.events.build(event_params)
    if @event.save
      redirect_to @event, notice: "Event was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  if current_user.role == "participant"
    @registration = current_user.registrations.find_by(event_id: @event.id)
    @payment = @registration&.payment
    @ticket = @registration&.ticket
  elsif current_user.role == "host" && current_user == @event.host
    @registrations = @event.registrations.includes(:user)
  else
    redirect_to root_path, alert: "You are not authorized to view this event."
  end
end


  def filtered
    @events = Event.where(category_id: current_user.interest)
  end

  def edit
    unless current_user == @event.host
      redirect_to events_path, alert: "You can only edit your own events."
    end
  end

  def update
    if current_user == @event.host
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
    if current_user == @event.host
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
    redirect_to root_path, alert: "Only hosts can access this page." unless current_user.role == "host"
  end

  def authorize_participant!
  redirect_to root_path, alert: "Only participants can access this section." unless current_user&.role == "participant"
end

end
