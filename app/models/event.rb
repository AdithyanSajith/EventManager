class Event < ApplicationRecord
  # Associations
  belongs_to :host, class_name: 'User'
  belongs_to :venue
  belongs_to :category

  has_many :reviews, as: :reviewable, dependent: :destroy
  has_many :registrations, dependent: :destroy

  # Specify source explicitly for clarity
  has_many :participants, through: :registrations, source: :user

  # Validations
  validates :title, :description, :starts_at, :ends_at, :venue_id, :category_id, presence: true
  validate :start_and_end_dates_must_be_valid

  # Custom validation to prevent past events and incorrect end times
  def start_and_end_dates_must_be_valid
    if starts_at.present? && starts_at < Time.current
      errors.add(:starts_at, "must be in the future")
    end

    if ends_at.present? && starts_at.present? && ends_at <= starts_at
      errors.add(:ends_at, "must be after the start time")
    end
  end

  # Ransack whitelisting for ActiveAdmin filters/search
  def self.ransackable_attributes(auth_object = nil)
    %w[
      id
      title
      description
      starts_at
      ends_at
      created_at
      updated_at
      host_id
      venue_id
      category_id
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[
      host
      venue
      category
      participants
      registrations
      reviews
    ]
  end
end
