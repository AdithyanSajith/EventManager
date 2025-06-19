module Api
  module V1
    module Events
      class RegistrationsController < Api::V1::BaseController
        before_action :authenticate_resource_owner!
        before_action :ensure_participant!
        before_action :set_event

        respond_to :json

        # GET /api/v1/events/:event_id/registration_status
        def status
          participant = current_resource_owner.userable
          registration = Registration.find_by(participant: participant, event: @event)
          ticket = registration&.ticket
          payment = registration&.payment

          render json: {
            registered: registration.present?,
            paid: payment.present?,
            ticket_id: ticket&.id
          }, status: :ok
        end

        # POST /api/v1/events/:event_id/registrations
        def create
          participant = current_resource_owner.userable
          registration = Registration.find_or_initialize_by(participant: participant, event: @event)

          if registration.persisted?
            render json: { message: "Already registered for this event." }, status: :ok
          else
            if registration.save
              render json: { message: "Registration successful." }, status: :created
            else
              render json: { errors: registration.errors.full_messages }, status: :unprocessable_entity
            end
          end
        end

        private

        def ensure_participant!
          unless current_resource_owner&.userable_type == 'Participant' && current_resource_owner.userable.present?
            render json: { error: 'Only participants can register for events.' }, status: :forbidden
          end
        end

        def set_event
          @event = Event.find(params[:event_id])
        rescue ActiveRecord::RecordNotFound
          render json: { error: "Event not found" }, status: :not_found
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
end
