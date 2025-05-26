module Api
  module V1
    module Events
      class RegistrationsController < ApplicationController
        before_action :authenticate_user!
        before_action :set_event
        respond_to :json

        def status
          participant = current_user.userable
          registration = Registration.find_by(participant: participant, event: @event)
          ticket = registration&.ticket
          payment = registration&.payment

          render json: {
            registered: registration.present?,
            paid: payment.present?,
            ticket_id: ticket&.id
          }
        end

        private

        def set_event
          @event = Event.find(params[:event_id])
        end
      end
    end
  end
end
