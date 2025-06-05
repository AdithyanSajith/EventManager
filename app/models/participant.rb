class Participant < ApplicationRecord
  # One user record associated polymorphically
  has_one :user, as: :userable, dependent: :destroy

  # Participant can register for many events
  has_many :registrations, foreign_key: :participant_id, dependent: :destroy
  has_many :events, through: :registrations

  # Participant can leave reviews on events or venues
  has_many :reviews, foreign_key: :participant_id, dependent: :destroy

  # Participant receives tickets and makes payments through registrations
  has_many :tickets, through: :registrations
  has_many :payments, through: :registrations

  # Validations specific to participants
  validates :name, :city, :interest, :birthdate, presence: true
  validates :interest, length: { maximum: 50 } # Match your spec!
  validates :city, length: { maximum: 100 }

  # Callback to ensure fields are initialized
  before_validation :set_default_interest
  before_validation :set_default_name
  before_validation :set_default_city
  before_validation :set_default_birthdate

  def self.ransackable_attributes(auth_object = nil)
    %w[id name interest city birthdate created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user registrations events reviews tickets payments]
  end

  private

  def set_default_interest
    self.interest ||= "No interest provided"
  end

  def set_default_name
    self.name ||= "No name provided"
  end

  def set_default_city
    self.city ||= "No city provided"
  end

  def set_default_birthdate
    self.birthdate ||= Date.new(2000, 1, 1)
  end
end
