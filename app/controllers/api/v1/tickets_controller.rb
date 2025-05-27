module Api
  module V1
    class TicketsController < ApplicationController
      before_action :doorkeeper_authorize!
      respond_to :json

      def show
        ticket = Ticket.find(params[:id])
        if ticket.registration.participant_id != current_resource_owner.userable&.id
          render json: { error: "Unauthorized access." }, status: :unauthorized
        else
          render json: {
            ticket_number: ticket.ticket_number,
            issued_at: ticket.issued_at,
            event: {
              title: ticket.registration.event.title,
              starts_at: ticket.registration.event.starts_at,
              ends_at: ticket.registration.event.ends_at,
              venue: ticket.registration.event.venue.name
            }
          }
        end
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Ticket not found." }, status: :not_found
      end
    end
  end
end
