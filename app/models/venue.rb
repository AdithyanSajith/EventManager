class Venue < ApplicationRecord
  belongs_to :host
  has_many :events, dependent: :nullify
  has_many :reviews, as: :reviewable, dependent: :destroy

  validates :name, :location, presence: true

  def self.ransackable_attributes(_auth = nil)
    %w[id name address city capacity location host_id created_at updated_at]
  end

  def self.ransackable_associations(_auth = nil)
    %w[host events reviews]
  end
end
