class TicketsController < ApplicationController
  layout "application"
  include SnackbarHelper
  
  before_action :authenticate_user!
  before_action :ensure_participant!

  def index
    @tickets = Ticket.all
  end

  def show
    @ticket = Ticket.find(params[:id])
    @registration = @ticket.registration

    # Allow admin users to view any ticket
    if current_admin_user
      # Show ticket viewed snackbar for admins
      @snackbar_js = ticket_snackbar(:issued, "Viewing ticket for #{@registration.event.title}")
      return
    end
    
    # For regular users, ensure the ticket belongs to the logged-in participant
    unless @registration.participant_id == current_user.userable_id
      render_flash_message(:error, "You are not authorized to view this ticket.")
      
      # Show snackbar for unauthorized access
      session[:ticket_snackbar] = { 
        action: :error, 
        details: "Unauthorized ticket access"
      }
      
      redirect_to filtered_events_path
    end
    
    # Show ticket viewed snackbar
    @snackbar_js = ticket_snackbar(:issued, "Ticket for #{@registration.event.title}")
    
  rescue ActiveRecord::RecordNotFound
    render_flash_message(:error, "Ticket not found.")
    
    # Show snackbar for not found
    session[:ticket_snackbar] = { 
      action: :error, 
      details: "Ticket not found"
    }
    
    redirect_to filtered_events_path
  end

  private

  def ensure_participant!
    # Allow admin users to access tickets
    if current_admin_user
      return true
    end
    
    # For regular users, ensure they are participants
    unless current_user && current_user.userable_type == "Participant"
      render_flash_message(:error, "Only participants can access tickets.")
      
      # Show snackbar for unauthorized userable type
      session[:ticket_snackbar] = { 
        action: :error, 
        details: "Only participants can access tickets"
      }
      
      redirect_to root_path
    end
  end
end