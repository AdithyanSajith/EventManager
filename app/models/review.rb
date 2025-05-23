class Review < ApplicationRecord
  belongs_to :reviewable, polymorphic: true
  belongs_to :participant

  validates :participant_id, uniqueness: { scope: [:reviewable_type, :reviewable_id], message: "already reviewed this item" }

  def self.ransackable_attributes(_auth = nil)
    %w[id rating comment participant_id reviewable_id reviewable_type created_at updated_at]
  end

  def self.ransackable_associations(_auth = nil)
    %w[participant reviewable]
  end
end
