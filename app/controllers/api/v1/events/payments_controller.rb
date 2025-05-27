module Api
  module V1
    module Events
      class PaymentsController < ApplicationController
        before_action :doorkeeper_authorize!
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
        end

        def payment_params
          params.require(:payment).permit(:amount, :card_number)
        end
      end
    end
  end
end
