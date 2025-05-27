module Api
  module V1
    module Events
      class ReviewsController < ApplicationController
        before_action :doorkeeper_authorize!
        before_action :set_event
        respond_to :json

        def index
          reviews = @event.reviews.includes(:participant)
          render json: reviews.as_json(
            include: { participant: { only: [:name] } },
            only: [:rating, :comment, :created_at]
          )
        end

        def create
          review = @event.reviews.new(review_params.merge(participant: current_resource_owner.userable))
          if review.save
            render json: { message: "Review submitted." }, status: :created
          else
            render json: { errors: review.errors.full_messages }, status: :unprocessable_entity
          end
        end

        private

        def set_event
          @event = Event.find(params[:event_id])
        end

        def review_params
          params.require(:review).permit(:rating, :comment)
        end
      end
    end
  end
end
