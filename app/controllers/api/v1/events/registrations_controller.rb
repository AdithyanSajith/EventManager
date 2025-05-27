module Api
  module V1
    module Events
      class RegistrationsController < ApplicationController
        skip_before_action :verify_authenticity_token, only: [:status]
        before_action :doorkeeper_authorize!
        before_action :set_event
        respond_to :json

        def status
          Rails.logger.info "Entered status action for event #{@event.id} and user #{current_resource_owner.id}"
          participant = current_resource_owner.userable
          registration = Registration.find_by(participant: participant, event: @event)
          if registration.nil?
            Rails.logger.info "No registration found for participant #{participant.id} and event #{@event.id}"
          end
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
          Rails.logger.info "Looking for Event with ID #{params[:event_id]}"
          @event = Event.find(params[:event_id])
          Rails.logger.info "Found event: #{@event.title}"
        rescue ActiveRecord::RecordNotFound => e
          Rails.logger.error "Event not found: #{e.message}"
          render json: { error: "Event not found" }, status: :not_found
        end
      end
    end
  end
end
