module Api
  module V1
    class TicketsController < ApplicationController
      before_action :authenticate_resource_owner!
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
          }, status: :ok
        end
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Ticket not found." }, status: :not_found
      end

      def index
        participant = current_resource_owner.userable
        unless current_resource_owner.userable_type == 'Participant' && participant.present?
          render json: { error: 'Only participants can view tickets.' }, status: :forbidden and return
        end

        tickets = Ticket.joins(:registration).where(registrations: { participant_id: participant.id })
        render json: tickets.map { |ticket|
          {
            id: ticket.id,
            ticket_number: ticket.ticket_number,
            issued_at: ticket.issued_at,
            event: {
              title: ticket.registration.event.title,
              starts_at: ticket.registration.event.starts_at,
              ends_at: ticket.registration.event.ends_at,
              venue: ticket.registration.event.venue.name
            }
          }
        }, status: :ok
      end

      # Combined auth supporting OAuth token or Devise session
      private

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
