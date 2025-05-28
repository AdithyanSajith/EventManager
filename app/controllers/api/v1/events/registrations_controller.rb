module Api
  module V1
    module Events
      class RegistrationsController < ApplicationController
        skip_before_action :verify_authenticity_token, only: [:status]

        before_action :authenticate_resource_owner!
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
          unless participant
            return render json: { error: "Participant profile not found" }, status: :unprocessable_entity
          end

          registration = Registration.find_or_initialize_by(participant: participant, event: @event)

          if registration.persisted?
            render json: { message: "Already registered for this event." }, status: :ok
          else
            registration.assign_attributes(registration_params)
            if registration.save
              render json: { message: "Registration successful." }, status: :created
            else
              render json: { errors: registration.errors.full_messages }, status: :unprocessable_entity
            end
          end
        end

        private

        def registration_params
          # Permit only participant_id and event_id inside registration params
          params.require(:registration).permit(:participant_id, :event_id)
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
