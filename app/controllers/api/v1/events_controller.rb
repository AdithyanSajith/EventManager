module Api
  module V1
    class EventsController < ApplicationController
      before_action :set_event, only: [:show, :update, :destroy]

      # GET /api/v1/events
      def index
        @events = Event.all
        render json: @events
      end

      # GET /api/v1/events/:id
      def show
        render json: @event
      end

      # POST /api/v1/events
      def create
        @event = Event.new(event_params)

        if @event.save
          render json: @event, status: :created
        else
          render json: @event.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/events/:id
      def update
        if @event.update(event_params)
          render json: @event
        else
          render json: @event.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/events/:id
      def destroy
        @event.destroy
        head :no_content
      end

      private

      # Set event for actions that need it (show, update, destroy)
      def set_event
        @event = Event.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Event not found" }, status: :not_found
      end

      # Event parameters allowed for create and update
      def event_params
        params.require(:event).permit(:title, :description, :starts_at, :ends_at, :host_id, :category_id, :venue_id)
      end
    end
  end
end
