class Registration < ApplicationRecord
  belongs_to :participant
  belongs_to :event
  has_one :payment, dependent: :destroy
  has_one :ticket, dependent: :destroy

  def self.ransackable_attributes(_auth = nil)
    %w[id status participant_id event_id created_at updated_at]
  end

  def self.ransackable_associations(_auth = nil)
    %w[participant event payment ticket]
  end
end