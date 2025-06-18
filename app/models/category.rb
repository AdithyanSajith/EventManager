class Category < ApplicationRecord
  # Associations
  has_many :events, dependent: :nullify

  # Validations
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  # Downcase name before saving for stricter uniqueness
  before_validation :downcase_name

  # Ransack/ActiveAdmin filterable fields
  def self.ransackable_attributes(auth_object = nil)
    %w[id name created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[events]
  end

  private
  def downcase_name
    self.name = name.downcase.strip if name.present?
  end
end
