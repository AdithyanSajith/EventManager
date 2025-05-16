class Registration < ApplicationRecord
  belongs_to :participant, class_name: "User"
  belongs_to :event
  has_one :payment, dependent: :destroy
  has_one :ticket, dependent: :destroy
end
