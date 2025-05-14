class Event < ApplicationRecord
  belongs_to :host
  belongs_to :category
  belongs_to :venue

  has_many :registrations, dependent: :destroy
  has_many :payments, through: :registrations
  has_many :tickets, through: :registrations
  has_many :reviews, as: :reviewable, dependent: :destroy
end
