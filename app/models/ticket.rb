class Ticket < ApplicationRecord
  belongs_to :registration
  delegate :participant, :event, to: :registration

  before_create :assign_ticket_number

  # Allowlist attributes for Ransack (used by ActiveAdmin)
  def self.ransackable_attributes(auth_object = nil)
    %w[
      id
      ticket_number
      issued_at
      registration_id
      created_at
      updated_at
    ]
  end

  private

  def assign_ticket_number
    self.ticket_number ||= SecureRandom.hex(6).upcase
    self.issued_at = Time.now
  end
end
