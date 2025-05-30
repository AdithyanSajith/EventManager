class Registration < ApplicationRecord
  belongs_to :participant
  belongs_to :event
  has_one :payment, dependent: :destroy
  has_one :ticket, dependent: :destroy

  # Callback to create a ticket after registration
  after_create :create_ticket

  def self.ransackable_attributes(_auth = nil)
    %w[id status participant_id event_id created_at updated_at]
  end

  def self.ransackable_associations(_auth = nil)
    %w[participant event payment ticket]
  end

  private

  # Create ticket after registration
  def create_ticket
    # Ticket creation logic
    ticket = self.create_ticket!(ticket_number: SecureRandom.hex(6), issued_at: Time.current)
    Rails.logger.info "Ticket created for participant: #{self.participant.name}, Event: #{self.event.title}"
  end
end
