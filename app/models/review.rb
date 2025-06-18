class Review < ApplicationRecord
  belongs_to :reviewable, polymorphic: true
  belongs_to :participant, polymorphic: true

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
    reviewable_object = self.reviewable
    if reviewable_object.is_a?(Event)
      reviewable_object.update_rating
      Rails.logger.info "Event rating updated for event: #{reviewable_object.title}"
    elsif reviewable_object.respond_to?(:update_rating)
      reviewable_object.update_rating
      Rails.logger.info "Rating updated for #{reviewable_object.class.name}"
    end
  end
end
