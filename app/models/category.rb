class Category < ApplicationRecord
  # Associations
  has_many :events, dependent: :nullify

  # Validations
  validates :name, presence: true, uniqueness: true

  # Ransack/ActiveAdmin filterable fields
  def self.ransackable_attributes(auth_object = nil)
    %w[id name created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[events]
  end
end
