module Api
  module V1
    module Events
      class PaymentsController < ApplicationController
        before_action :authenticate_resource_owner!
        before_action :set_event
        respond_to :json

        def create
          participant = current_resource_owner.userable
          registration = Registration.find_or_create_by(participant: participant, event: @event)

          if registration.payment.present?
            render json: { message: "Payment already completed." }, status: :ok
            return
          end

          payment = registration.build_payment(payment_params)
          if payment.save
            registration.create_ticket!(ticket_number: SecureRandom.hex(6), issued_at: Time.current)
            render json: { message: "Payment successful. Ticket issued." }, status: :created
          else
            render json: { errors: payment.errors.full_messages }, status: :unprocessable_entity
          end
        end

        private

        def set_event
          @event = Event.find(params[:event_id])
        rescue ActiveRecord::RecordNotFound
          render json: { error: "Event not found" }, status: :not_found
        end

        def payment_params
          params.require(:payment).permit(:amount, :card_number)
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
end
