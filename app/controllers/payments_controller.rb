class PaymentsController < ApplicationController
  # Use Devise's authenticate_user! for web-based authentication
  before_action :authenticate_user!
  before_action :authorize_participant!
  before_action :set_event

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
      unless @registration.ticket
        Ticket.create!(
          registration: @registration,
          ticket_number: SecureRandom.hex(6),
          issued_at: Time.current
        )
      end

      flash[:notice] = "✅ Payment successful and ticket issued!"
      redirect_to filtered_events_path
    else
      flash.now[:alert] = @payment.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def payment_params
    params.require(:payment).permit(:amount, :card_number)
  end

  def authorize_participant!
    unless current_resource_owner.role == "participant"
      redirect_to root_path, alert: "Only participants can make payments."
    end
  end
end
