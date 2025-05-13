class PaymentsController < ApplicationController
  before_action :authenticate_participant!
  before_action :set_event

  def new
    @registration = current_participant.registrations.find_or_initialize_by(event: @event)
  end

  def change_category
  @categories = Category.all
end

def update_interest
  if current_participant.update(interest: params[:interest])
    redirect_to filtered_events_path, notice: "Category updated successfully!"
  else
    redirect_to change_category_path, alert: "Failed to update category."
  end
end


  def create
    @registration = current_participant.registrations.find_or_initialize_by(event: @event)

    if @registration.save
      @payment = @registration.build_payment(payment_params.merge(status: "paid", paid_at: Time.current))
      if @payment.save
        @registration.create_ticket(ticket_number: SecureRandom.hex(6), issued_at: Time.current)
        redirect_to @event, notice: "Payment successful. You are now registered, and your ticket has been issued."
      else
        flash.now[:alert] = "Payment failed."
        render :new, status: :unprocessable_entity
      end
    else
      redirect_to events_path, alert: "Registration could not be created."
    end
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def payment_params
    params.require(:payment).permit(:amount)
  end
end
