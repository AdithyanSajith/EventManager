class Ticket < ApplicationRecord
  belongs_to :registration
  delegate :participant, :event, to: :registration

  before_create :assign_ticket_number

  private

  def assign_ticket_number
    self.ticket_number ||= SecureRandom.hex(6).upcase
    self.issued_at = Time.now
  end
end
