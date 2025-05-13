class EventsController < ApplicationController
  before_action :set_event, only: %i[show edit update destroy]
  before_action :authenticate_participant!, only: [:show]

  def show
    @registration = current_participant.registrations.find_by(event: @event)
    @payment = @registration&.payment
    @ticket = @registration&.ticket
  end

  def index
    @events = Event.all
  end

  def new
    @event = Event.new
  end
  
  def filtered
  @events = Event.joins(:category).where(categories: { name: current_participant.interest })
  render :filtered
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
    @event.destroy
    redirect_to events_path, notice: "Event was successfully destroyed."
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :description, :starts_at, :ends_at, :category_id, :venue_id)
  end
end
