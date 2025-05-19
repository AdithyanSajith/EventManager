class Event < ApplicationRecord
  # Associations
  belongs_to :host, class_name: 'User'
  belongs_to :venue
  belongs_to :category

  has_many :reviews, as: :reviewable, dependent: :destroy
  has_many :registrations, dependent: :destroy

  # Specify source explicitly for clarity
  has_many :participants, through: :registrations, source: :user

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
