module Api
  module V1
    class EventsController < ApplicationController
      before_action :authenticate_resource_owner!, except: [:index, :show]
      before_action :set_event, only: [:show, :update, :destroy]
      respond_to :json

      def index
        @events = Event.all
        render json: @events, status: :ok
      end

      def show
        render json: @event, status: :ok
      end

      def create
        @event = Event.new(event_params)
        if @event.save
          render json: @event, status: :created
        else
          render json: @event.errors, status: :unprocessable_entity
        end
      end

      def update
        if @event.update(event_params)
          render json: @event, status: :ok
        else
          render json: @event.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @event.destroy
        head :no_content
      end

      private

      def set_event
        @event = Event.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Event not found" }, status: :not_found
      end

      def event_params
        params.require(:event).permit(:title, :description, :starts_at, :ends_at, :host_id, :category_id, :venue_id)
      end

      # Combined auth supporting OAuth token or Devise session
      def authenticate_resource_owner!
        if doorkeeper_token
          doorkeeper_authorize!
        else
          authenticate_user!
        end
      end

      def current_resource_owner
        if doorkeeper_token
          User.find(doorkeeper_token.resource_owner_id)
        else
          current_user
        end
      end
      helper_method :current_resource_owner
    end
  end
end
