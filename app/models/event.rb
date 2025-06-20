class Event < ApplicationRecord
  belongs_to :host
  belongs_to :venue
  belongs_to :category

  has_many :reviews, as: :reviewable, dependent: :destroy
  has_many :registrations, dependent: :destroy
  has_many :participants, through: :registrations
  has_many :tickets, dependent: :destroy

  validates :title, :description, :starts_at, :ends_at, :venue_id, :category_id, :host_id, presence: true
  validate :start_and_end_dates_must_be_valid

  # Normalize event title before validation
  before_validation :normalize_title
  # Prevent destroy if registrations exist
  before_destroy :check_for_registrations
  # Notify host after event creation
  after_create :notify_host_of_event_creation

  def start_and_end_dates_must_be_valid
    errors.add(:starts_at, "must be in the future") if starts_at.present? && starts_at < Time.current
    if ends_at.present? && starts_at.present? && ends_at <= starts_at
      errors.add(:ends_at, "must be after the start time")
    end
  end

  def average_rating
    reviews.average(:rating)&.round(2) || 0.0
  end

  def self.ransackable_attributes(_auth = nil)
    %w[id title description starts_at ends_at created_at updated_at host_id venue_id category_id]
  end

  def self.ransackable_associations(_auth = nil)
    %w[host venue category participants registrations reviews]
  end

  private

  # Format title before validation
  def normalize_title
    self.title = title.strip.titleize if title.present?
  end

  # Prevent destroy if event has registrations
  def check_for_registrations
    if registrations.exists?
      errors.add(:base, "Cannot delete event with registrations.")
      throw :abort
    end
  end

  # Log event creation (already present)
  def notify_host_of_event_creation
    Rails.logger.info "Host notified about event: #{self.title}"
  end

  public

  # Update rating (stub method to prevent NoMethodError)
  def update_rating
    # No-op or implement logic if you want to cache average rating
    # For now, this can be left empty or log the update
    Rails.logger.info "update_rating called for event: \\#{self.id}"
  end
end