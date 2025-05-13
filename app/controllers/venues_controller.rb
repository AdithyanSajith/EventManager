class VenuesController < ApplicationController
  before_action :authenticate_host!                  # Require host login
  before_action :set_venue, only: %i[ show edit update destroy ]

  # GET /venues
  def index
    # Show only venues created by the current host
    @venues = current_host.venues
  end

  # GET /venues/1
  def show
  end

  # GET /venues/new
  def new
    @venue = Venue.new
  end

  # GET /venues/1/edit
  def edit
  end

  # POST /venues
  def create
    @venue = current_host.venues.build(venue_params)

    if @venue.save
      redirect_to @venue, notice: "Venue was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /venues/1
  def update
    if @venue.update(venue_params)
      redirect_to @venue, notice: "Venue was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /venues/1
  def destroy
    @venue.destroy!
    redirect_to venues_path, notice: "Venue was successfully destroyed.", status: :see_other
  end

  private

    # Find the venue by ID
    def set_venue
      @venue = current_host.venues.find(params[:id])
      # Ensures host can only edit their own venues
    end

    # Strong parameters — only allow these fields
    def venue_params
      params.require(:venue).permit(:name, :location, :capacity)
    end
end
