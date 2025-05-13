class Registration < ApplicationRecord
  belongs_to :participant
  belongs_to :event
  has_one :payment, dependent: :destroy
  has_one :ticket, dependent: :destroy
end
