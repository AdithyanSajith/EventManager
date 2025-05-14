class Review < ApplicationRecord
  belongs_to :participant
  belongs_to :reviewable, polymorphic: true
end
