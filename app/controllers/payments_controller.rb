class PaymentsController < ApplicationController
  layout "application"
  # Use Devise's authenticate_user! for web-based authentication
  before_action :authenticate_user!
  before_action :authorize_participant!
  before_action :set_event

  def index
    @payments = Payment.all
  end

  def show
    begin
      @payment = Payment.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path, alert: "Payment not found."
    end
  end

  def new
    participant = current_resource_owner.userable
    unless participant
      redirect_to root_path, alert: "Participant profile not found. Please contact support."
      return
    end

    @registration = Registration.find_or_create_by!(
      participant_id: participant.id,
      event_id: @event.id
    )
    @payment = Payment.new
  end

  def create
    participant = current_resource_owner.userable
    unless participant
      redirect_to root_path, alert: "Participant profile not found. Please contact support."
      return
    end

    @registration = Registration.find_or_create_by!(
      participant_id: participant.id,
      event_id: @event.id
    )

    if @registration.payment
      flash.now[:alert] = "You have already completed payment for this event."
      @payment = @registration.payment
      render :new, status: :unprocessable_entity
      return
    end

    @payment = @registration.build_payment(payment_params)

    if @payment.save
      ticket_issued = false
      unless @registration.ticket
        ticket = Ticket.create!(
          registration: @registration,
          ticket_number: SecureRandom.hex(6),
          issued_at: Time.current
        )
        ticket_issued = true
      end

      # Standard flash message for page reload
      render_flash_message(:success, "Payment successful and ticket issued!")
      
      # Store success message for snackbar in session
      message = ticket_issued ? "Payment successful and ticket issued!" : "Payment successful!"
      session[:payment_snackbar] = { action: :success, details: message }
      
      # Redirect to ticket page instead of filtered events
      redirect_to ticket_path(@registration.ticket)
    else
      # Standard flash message
      render_flash_message(:error, @payment.errors.full_messages.to_sentence)
      
      # Snackbar message shown immediately
      @snackbar_js = payment_snackbar(:error, @payment.errors.full_messages.to_sentence)
      
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @payment = Payment.find(params[:id])
    if @payment.update(payment_params)
      redirect_to @payment
    else
      render :edit
    end
  end

  def destroy
    @payment = Payment.find(params[:id])
    @payment.destroy
    redirect_to payments_path
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def payment_params
    params.require(:payment).permit(:registration_id, :amount, :card_number, :paid_at)
  end

  def authorize_participant!
    # Allow admin users automatic access
    if current_resource_owner.is_a?(AdminUser)
      return true
    end
    
    # For regular users, check for participant role
    unless current_resource_owner.is_a?(User) && current_resource_owner.role == "participant"
      render_flash_message(:error, "Only participants can make payments.")
      redirect_to root_path
    end
  end
end
