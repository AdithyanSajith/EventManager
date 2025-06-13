class Payment < ApplicationRecord
  belongs_to :registration

  validates :amount, numericality: { greater_than_or_equal_to: 0 }
  # Card number must be present, numeric, and 10-20 digits (adjust as needed)
  validates :card_number, presence: true, format: { with: /\A\d{10,20}\z/, message: "must be 10-20 digits" }

  # Callback to notify participant when payment is completed
  after_create :send_payment_confirmation

  def self.ransackable_attributes(_auth = nil)
    %w[id amount card_number status paid_at registration_id created_at updated_at]
  end

  private

  def send_payment_confirmation
    # You can add a real email sending logic here, e.g.,
    # PaymentMailer.with(payment: self).payment_successful.deliver_later
    Rails.logger.info "Payment received for registration ID: #{self.registration.id}"
  end
end
