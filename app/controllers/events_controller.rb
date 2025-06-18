class EventsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]
  layout "application"
  before_action :authenticate_resource_owner!, except: [:show]
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :authorize_host!, only: [:new, :create, :edit, :update, :destroy, :index, :other_events]
  before_action :authorize_participant!, only: [:filtered]

  def index
    @events = Event.all
  end

  def new
    @event = Event.new
  end
  # Error 422 Unprocessable Enitity
  def create
    @event = current_resource_owner.userable.events.build(event_params)
    if @event.save
      render_flash_message(:success, "Event was successfully created.")
      redirect_to @event
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @event = Event.find(params[:id])
    # Allow anyone to view event details, but only show registration/payment/ticket if logged in and authorized
    if user_signed_in? || current_admin_user
      # Admin users can see all registrations
      if current_resource_owner.is_a?(AdminUser)
        @registrations = @event.registrations.includes(:user)
      # For regular users, show appropriate information based on userable type or association
      elsif current_resource_owner.is_a?(User)
        if current_resource_owner.userable_type == "Participant"
          @registration = current_resource_owner.userable.registrations.find_by(event_id: @event.id)
          @payment = @registration&.payment
          @ticket = @registration&.ticket
        elsif current_resource_owner.userable_type == "Host" && current_resource_owner.userable == @event.host
          @registrations = @event.registrations.includes(:user)
        end
      end
    end
    # Render show view for all users (even if not logged in)
  end

  def filtered
    @events = Event.all.includes(:venue, :reviews)

    # Apply filters
    if params[:category_id].present?
      @events = @events.where(category_id: params[:category_id])
    end

    if params[:location].present?
      @events = @events.joins(:venue).where("venues.location ILIKE ?", "%#{params[:location]}%")
    end

    if params[:start_date].present? && params[:end_date].present?
      @events = @events.where("starts_at BETWEEN ? AND ?", params[:start_date], params[:end_date])
    end

    # Sorting
    if params[:sort_by] == "popularity"
      @events = @events.order(registrations_count: :desc)
    elsif params[:sort_by] == "date"
      @events = @events.order(starts_at: :asc)
    end
  end

  def other_events
    if current_resource_owner.is_a?(AdminUser)
      # Admin users see all events
      @events = Event.all
    elsif current_resource_owner.is_a?(User) && current_resource_owner.userable_type == "Host"
      # For hosts, show events from other hosts
      @events = Event.where.not(host_id: current_resource_owner.userable.id)
    else
      # Default for other user types
      @events = Event.all
    end
  end

  def edit
    # Admin users can edit any event
    if current_resource_owner.is_a?(AdminUser)
      return # Allow access
    end
    
    # Regular users can only edit their own events
    unless current_resource_owner.is_a?(User) && current_resource_owner.userable == @event.host
      render_flash_message(:error, "You can only edit your own events.")
      redirect_to events_path
    end
  end

  def update
    # Admin users can update any event
    if current_resource_owner.is_a?(AdminUser)
      if @event.update(event_params)
        render_flash_message(:success, "Event was successfully updated.")
        redirect_to @event
      else
        render :edit, status: :unprocessable_entity
      end
    # Regular users can only update their own events  
    elsif current_resource_owner.is_a?(User) && current_resource_owner.userable == @event.host
      if @event.update(event_params)
        render_flash_message(:success, "Event was successfully updated.")
        redirect_to @event
      else
        render :edit, status: :unprocessable_entity
      end
    else
      render_flash_message(:error, "You can only update your own events.")
      redirect_to events_path
    end
  end

  def destroy
    # Admin users can delete any event
    if current_resource_owner.is_a?(AdminUser)
      @event.destroy
      render_flash_message(:success, "Event deleted successfully.")
      redirect_to events_path
    # Regular users can only delete their own events
    elsif current_resource_owner.is_a?(User) && current_resource_owner.userable == @event.host
      @event.destroy
      render_flash_message(:success, "Event deleted successfully.")
      redirect_to hosted_events_path
    else
      render_flash_message(:error, "You are not authorized to delete this event.")
      redirect_to events_path
    end
  end

  def download_ics
    event = Event.find(params[:id])
    ics_content = helpers.ics_event_content(event)
    send_data ics_content, filename: "#{event.title.parameterize}.ics", type: 'text/calendar'
  end

  def past_events
    if current_resource_owner.is_a?(User) && current_resource_owner.userable_type == "Host"
      # Show only past events hosted by this host
      @events = Event.where(host_id: current_resource_owner.userable.id)
                     .where("ends_at < ?", Time.current)
    elsif current_resource_owner.is_a?(User) && current_resource_owner.userable_type == "Participant"
      # Show only past events the participant registered for
      participant = current_resource_owner.userable
      @events = Event.joins(:registrations)
                     .where(registrations: { participant_id: participant.id })
                     .where("ends_at < ?", Time.current)
                     .distinct
    else
      @events = Event.none
    end
  end

  def hosted
    Rails.logger.debug "Current Resource Owner: #{current_resource_owner.inspect}"

    if current_resource_owner.is_a?(AdminUser)
      @events = Event.where('starts_at > ?', Time.current)
    elsif current_resource_owner.is_a?(User) && current_resource_owner.userable_type == "Host"
      Rails.logger.debug "Host ID: #{current_resource_owner.userable.id}"
      @events = Event.where(host_id: current_resource_owner.userable.id).where('starts_at > ?', Time.current)
      Rails.logger.debug "Hosted Events: #{@events.inspect}"
    else
      @events = Event.none
    end
  end

  def other_hosts_events
    @events = Event.where.not(host_id: current_resource_owner.userable.id)
  end

  private

  def set_event
    @event = Event.find_by(id: params[:id])
    unless @event
      render_flash_message(:error, "Event not found or already deleted.")
      redirect_to events_path and return
    end
  end

  def event_params
    params.require(:event).permit(:title, :description, :starts_at, :ends_at, :category_id, :venue_id, :fee)
  end

  def authorize_host!
    # Allow admin users automatic access
    if current_resource_owner.is_a?(AdminUser)
      return true
    end
    
    # For regular users, check for host association
    unless current_resource_owner&.is_a?(User) && 
           current_resource_owner&.userable.present? && 
           current_resource_owner&.userable_type == "Host"
      render_flash_message(:error, "Only hosts can access this page.")
      redirect_to root_path
    end
  end

  def authorize_participant!
    # Allow admin users automatic access
    if current_resource_owner.is_a?(AdminUser)
      return true
    end
    
    # For regular users, check for participant association
    unless current_resource_owner&.is_a?(User) && 
           current_resource_owner&.userable.present? && 
           current_resource_owner&.userable_type == "Participant"
      render_flash_message(:error, "Only participants can access this section.")
      redirect_to root_path
    end
  end
end
