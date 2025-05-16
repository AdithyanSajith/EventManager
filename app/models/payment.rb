class Payment < ApplicationRecord
  belongs_to :registration

  delegate :event, to: :registration
end
