class Payment < ApplicationRecord
  belongs_to :registration

  def self.ransackable_attributes(_auth = nil)
    %w[id amount card_number status paid_at registration_id created_at updated_at]
  end
end
