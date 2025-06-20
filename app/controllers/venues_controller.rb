class VenuesController < ApplicationController
  before_action :authenticate_resource_owner!
  before_action :ensure_host!
  before_action :set_venue, only: %i[show edit update destroy]

  def index
    @venues = Venue.all
  end

  def show
    @venue = Venue.find(params[:id])
  end

  def new
    @venue = Venue.new
  end

  def edit
  end

  def create
    @venue = current_resource_owner.userable.venues.build(venue_params)

    if @venue.save
      redirect_to new_event_path, notice: "Venue was successfully created. You can now create your event using this venue."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @venue.update(venue_params)
      redirect_to venues_path, notice: "Venue was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @venue.destroy!
    redirect_to venues_path, notice: "Venue was successfully destroyed.", status: :see_other
  end

  private

  def set_venue
    @venue = Venue.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to venues_path, alert: "Venue not found."
  end

  def venue_params
    params.require(:venue).permit(:name, :location, :capacity, :address, :city)
  end

  def ensure_host!
    if current_resource_owner.is_a?(AdminUser)
      return true # Admin users are allowed
    end

    unless current_resource_owner.is_a?(User) && current_resource_owner.userable_type == "Host"
      redirect_to root_path, alert: "Only hosts can manage venues."
    end
  end
end
