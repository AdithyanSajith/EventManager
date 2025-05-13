class Event < ApplicationRecord
  belongs_to :host
  belongs_to :category
  belongs_to :venue

  has_many :registrations
  has_many :participants, through: :registrations
  has_many :payments, through: :registrations
  has_many :reviews
end
