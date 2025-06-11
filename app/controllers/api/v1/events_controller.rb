module Api
  module V1
    class EventsController < ApplicationController
      before_action :authenticate_resource_owner!, except: [:index, :show, :top_rated]
      before_action :set_event, only: [:show, :update, :destroy]
      before_action :check_event_time, only: [:update, :destroy]
      before_action :ensure_host!, only: [:create, :update, :destroy]
      respond_to :json

      def index
        @events = Event.all
        render json: @events, status: :ok
      end

      def show
        render json: @event, status: :ok
      end

      def create
        @event = current_resource_owner.userable.events.build(event_params)

        if @event.save
          render json: @event, status: :created
        else
          render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        unless owns_event?(@event)
          return render json: { error: 'Only the event host can update this event.' }, status: :unauthorized
        end

        if @event.update(event_params)
          render json: @event, status: :ok
        else
          render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        unless owns_event?(@event)
          return render json: { error: 'Only the event host can delete this event.' }, status: :unauthorized
        end

        @event.destroy
        head :no_content
      end

      def top_rated
        top_events = Event
          .left_joins(:reviews)
          .group('events.id')
          .select('events.*, AVG(reviews.rating) as average_rating')
          .order('average_rating DESC NULLS LAST')
          .limit(5)

        render json: top_events.as_json(
          only: [:id, :title, :description, :starts_at, :ends_at],
          methods: [:average_rating]
        )
      end

      private

      def set_event
        @event = Event.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Event not found" }, status: :not_found
      end

      def event_params
        params.require(:event).permit(:title, :description, :starts_at, :ends_at, :category_id, :venue_id)
      end

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

      def check_event_time
        if @event.starts_at < Time.current
          render json: { error: 'Cannot modify events that have already started.' }, status: :forbidden
        end
      end

      def ensure_host!
        unless current_resource_owner&.role == 'host' && current_resource_owner.userable.present?
          render json: { error: 'Only authenticated hosts can perform this action.' }, status: :forbidden
        end
      end

      def owns_event?(event)
        current_resource_owner&.role == 'host' && event.host_id == current_resource_owner.userable.id
      end

      helper_method :current_resource_owner
    end
  end
end
