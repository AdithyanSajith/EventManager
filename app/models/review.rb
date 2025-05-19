class Review < ApplicationRecord
  belongs_to :reviewable, polymorphic: true
  belongs_to :participant, class_name: "User", foreign_key: "participant_id"

  validates :participant_id, uniqueness: {
    scope: [:reviewable_type, :reviewable_id],
    message: "has already submitted a review for this item"
  }

  def self.ransackable_attributes(auth_object = nil)
    %w[
      id
      content
      rating
      participant_id
      reviewable_id
      reviewable_type
      created_at
      updated_at
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[
      participant
      reviewable
    ]
  end
end
