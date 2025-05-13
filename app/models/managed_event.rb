class ManagedEvent < ApplicationRecord
  belongs_to :host
  belongs_to :category
  belongs_to :venue
end
