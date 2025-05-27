class Review < ApplicationRecord
  belongs_to :reviewable, polymorphic: true
  belongs_to :participant

  validates :participant_id, uniqueness: { scope: [:reviewable_type, :reviewable_id], message: "already reviewed this item" }

  # Callback to update event rating after review creation
  after_create :update_event_rating

  def self.ransackable_attributes(_auth = nil)
    %w[id rating comment participant_id reviewable_id reviewable_type created_at updated_at]
  end

  def self.ransackable_associations(_auth = nil)
    %w[participant reviewable]
  end

  private

  def update_event_rating
    # Update event's rating logic
    event = self.reviewable
    event.update_rating if event.is_a?(Event)
    Rails.logger.info "Event rating updated for event: #{event.title}"
  end
end
