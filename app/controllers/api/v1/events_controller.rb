module Api
  module V1
    class EventsController < Api::V1::BaseController
      skip_before_action :doorkeeper_authorize!, only: [:index, :show, :top_rated]
      before_action :authenticate_resource_owner!, except: [:index, :show, :top_rated] # Allow public access to index and show actions
      before_action :set_event, only: [:show, :update, :destroy]
      before_action :check_event_time, only: [:update, :destroy] # Prevent modification of past events
      before_action :ensure_host!, only: [:create, :update, :destroy] 
      before_action :ensure_event_belongs_to_host!, only: [:update, :destroy]
      respond_to :json

      def index
        @events = Event.all
        render json: @events, status: :ok
      end

      def show
        render json: @event, status: :ok # Render the event details
      end

      def create
        # Only allow hosts to create events for themselves
        unless current_resource_owner.userable_type == 'Host'
          return render json: { error: 'Only hosts can create events.' }, status: :forbidden
        end
        @event = current_resource_owner.userable.events.build(event_params)

        if @event.save
          render json: @event, status: :created
        else
          render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        # Only allow hosts to update their own events
        unless owns_event?(@event)
          return render json: { error: 'Only the event host can update this event.' }, status: :forbidden
        end

        if @event.update(event_params)
          render json: @event, status: :ok
        else
          render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        # Only allow hosts to delete their own events
        unless owns_event?(@event)
          return render json: { error: 'Only the event host can delete this event.' }, status: :forbidden
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
        # Only allow hosts to access their own events for update/destroy
        if %w[update destroy].include?(action_name) && current_resource_owner.userable_type == 'Host'
          unless @event.host_id == current_resource_owner.userable.id
            render json: { error: 'You do not have permission to access this event.' }, status: :forbidden
          end
        end
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Event not found' }, status: :not_found
      end

      def event_params
        params.require(:event).permit(:title, :description, :starts_at, :ends_at, :category_id, :venue_id, :fee)
      end

      def check_event_time
        if @event.starts_at < Time.current
          render json: { error: 'Cannot modify events that have already started.' }, status: :forbidden
        end
      end

      def ensure_host!
        unless current_resource_owner&.userable_type == 'Host' && current_resource_owner.userable.present?
          render json: { error: 'Only authenticated hosts can perform this action.' }, status: :forbidden
        end
      end

      def ensure_event_belongs_to_host!
        unless @event.host_id == current_resource_owner.userable.id
          render json: { error: 'You do not have permission to modify this event.' }, status: :forbidden
        end
      end

      def owns_event?(event)
        event.host_id == current_resource_owner.userable.id if current_resource_owner&.userable.present?
      end

      def authenticate_resource_owner!  # Ensure the user is authenticated
        if doorkeeper_token
          doorkeeper_authorize! # Use Doorkeeper for OAuth token authentication
        else # Use Devise for web-based authentication
          authenticate_user! 
        end
      end

      def current_resource_owner # Determine the current resource owner based on the authentication method
        if doorkeeper_token
          User.find(doorkeeper_token.resource_owner_id) # For OAuth, find the user by token
        else
          current_user # For Devise, use the current user
        end
      end

      helper_method :current_resource_owner
    end
  end
end
