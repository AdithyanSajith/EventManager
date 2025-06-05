class Registration < ApplicationRecord
  belongs_to :participant
  belongs_to :event
  has_one :payment, dependent: :destroy
  has_one :ticket, dependent: :destroy

  after_create :create_ticket_unless_exists

  def self.ransackable_attributes(_auth = nil)
    %w[id status participant_id event_id created_at updated_at]
  end

  def self.ransackable_associations(_auth = nil)
    %w[participant event payment ticket]
  end

  private

  def create_ticket_unless_exists
    unless self.ticket
      Ticket.create!(
        registration: self,
        ticket_number: SecureRandom.hex(6).upcase,
        issued_at: Time.current
      )
      Rails.logger.info "Ticket created for participant: #{self.participant.name}, Event: #{self.event.title}"
    end
  end
end