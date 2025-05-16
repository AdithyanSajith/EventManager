class User < ApplicationRecord
  # Hosted events
  has_many :events, foreign_key: :host_id, dependent: :destroy

  # Participant event registrations
  has_many :registrations, foreign_key: :participant_id, dependent: :destroy
  has_many :registered_events, through: :registrations, source: :event

  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
