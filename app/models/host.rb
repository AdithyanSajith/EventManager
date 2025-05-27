class Host < ApplicationRecord
  # One user record associated polymorphically
  has_one :user, as: :userable, dependent: :destroy

  # Host can create many events and venues
  has_many :events, foreign_key: :host_id, dependent: :destroy
  has_many :venues, foreign_key: :host_id, dependent: :destroy

  # Host-specific validations
  validates :organisation, :website, :bio, :number, presence: true
  validates :number, numericality: { only_integer: true }, length: { is: 10 }

  # Callback to ensure bio is set if missing
  before_create :set_default_bio

  def self.ransackable_attributes(auth_object = nil)
    %w[id bio organisation website number created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user events venues]
  end

  private

  def set_default_bio
    self.bio ||= "No bio provided." # Set a default bio if not provided
  end
end
