class Registration < ApplicationRecord
  belongs_to :participant, class_name: "User"
  belongs_to :event
  has_one :payment, dependent: :destroy
  has_one :ticket, dependent: :destroy

  def self.ransackable_attributes(auth_object = nil)
    %w[
      id
      status
      participant_id
      event_id
      created_at
      updated_at
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[
      participant
      event
      payment
      ticket
    ]
  end
end
