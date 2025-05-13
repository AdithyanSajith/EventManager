class ManagedEventsController < ApplicationController
  before_action :set_managed_event, only: %i[ show edit update destroy ]

  # GET /managed_events or /managed_events.json
  def index
    @managed_events = ManagedEvent.all
  end

  # GET /managed_events/1 or /managed_events/1.json
  def show
  end

  # GET /managed_events/new
  def new
    @managed_event = ManagedEvent.new
  end

  # GET /managed_events/1/edit
  def edit
  end

  # POST /managed_events or /managed_events.json
  def create
    @managed_event = ManagedEvent.new(managed_event_params)

    respond_to do |format|
      if @managed_event.save
        format.html { redirect_to @managed_event, notice: "Managed event was successfully created." }
        format.json { render :show, status: :created, location: @managed_event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @managed_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /managed_events/1 or /managed_events/1.json
  def update
    respond_to do |format|
      if @managed_event.update(managed_event_params)
        format.html { redirect_to @managed_event, notice: "Managed event was successfully updated." }
        format.json { render :show, status: :ok, location: @managed_event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @managed_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /managed_events/1 or /managed_events/1.json
  def destroy
    @managed_event.destroy!

    respond_to do |format|
      format.html { redirect_to managed_events_path, status: :see_other, notice: "Managed event was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_managed_event
      @managed_event = ManagedEvent.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def managed_event_params
      params.require(:managed_event).permit(:title, :description, :starts_at, :ends_at, :host_id, :category_id, :venue_id)
    end
end
