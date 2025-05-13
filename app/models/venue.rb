class Venue < ApplicationRecord
  belongs_to :host
  has_many :events, dependent: :nullify

  validates :name, :location, presence: true
end
