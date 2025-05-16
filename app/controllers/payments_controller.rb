### ✅ app/controllers/payments_controller.rb

class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_participant!
  before_action :set_event

  def new
    @registration = Registration.find_or_create_by!(participant_id: current_user.id, event_id: @event.id)

    if @registration.payment
      redirect_to @event, notice: "You have already paid for this event."
    else
      @payment = @registration.build_payment
    end
  end

  def create
    @registration = Registration.find_or_create_by!(participant_id: current_user.id, event_id: @event.id)

    if @registration.payment
      redirect_to @event, notice: "Payment already made."
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
      redirect_to @event, notice: "Payment successful and ticket issued!"
    else
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
    redirect_to root_path, alert: "Only participants can make payments." unless current_user.role == "participant"
  end
end