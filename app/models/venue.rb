class Venue < ApplicationRecord
  belongs_to :host, class_name: "User"
  has_many :events, dependent: :nullify
  has_many :reviews, as: :reviewable, dependent: :destroy

  validates :name, :location, presence: true

  # ✅ Required by ActiveAdmin (Ransack) to allow filtering/searching
  def self.ransackable_attributes(auth_object = nil)
    %w[id name address city capacity location host_id created_at updated_at]
  end

  # ✅ Optional: allow filtering on associations
  def self.ransackable_associations(auth_object = nil)
    %w[host events reviews]
  end
end
