module Api
  module V1
    class EventsController < ApplicationController
      before_action :authenticate_resource_owner!, except: [:index, :show, :top_rated]
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
        unless current_resource_owner&.role == 'host'
          render json: { error: 'Only hosts can create events.' }, status: :forbidden and return
        end

        @event = current_resource_owner.userable.events.build(event_params)

        if @event.save
          render json: @event, status: :created
        else
          render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        unless @event.host == current_resource_owner.userable
          return render json: { error: 'Unauthorized' }, status: :unauthorized
        end

        if @event.update(event_params)
          render json: @event, status: :ok
        else
          render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        unless @event.host == current_resource_owner.userable
          return render json: { error: 'Unauthorized' }, status: :unauthorized
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

      helper_method :current_resource_owner
    end
  end
end
