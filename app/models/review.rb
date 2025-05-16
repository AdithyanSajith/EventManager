class Review < ApplicationRecord
  belongs_to :reviewable, polymorphic: true
  belongs_to :participant, class_name: "User", foreign_key: "participant_id"
end
