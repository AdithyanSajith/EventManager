module Api
  module V1
    module Events
      class ReviewsController < ApplicationController
        before_action :authenticate_resource_owner!
        before_action :set_event
        respond_to :json

        # GET /api/v1/events/:event_id/reviews
        def index
          reviews = @event.reviews.includes(:participant)
          render json: reviews.as_json(
            include: { participant: { only: [:name] } },
            only: [:rating, :comment, :created_at]
          ), status: :ok
        end

        # POST /api/v1/events/:event_id/reviews
        def create
          review = @event.reviews.new(review_params.merge(participant: current_resource_owner.userable))
          if review.save
            render json: { message: "Review submitted." }, status: :created
          else
            render json: { errors: review.errors.full_messages }, status: :unprocessable_entity
          end
        end

        private

        # Set event based on event_id param
        def set_event
          @event = Event.find(params[:event_id])
        rescue ActiveRecord::RecordNotFound
          render json: { error: "Event not found" }, status: :not_found
        end

        # Strong params for review creation
        def review_params
          params.require(:review).permit(:rating, :comment)
        end

        # Authentication supporting Doorkeeper OAuth token or Devise session
        def authenticate_resource_owner!
          if doorkeeper_token
            doorkeeper_authorize!
          else
            authenticate_user!
          end
        end

        # Helper to get current user from token or session
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
end
