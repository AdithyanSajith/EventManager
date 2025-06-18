class User < ApplicationRecord
  belongs_to :userable, polymorphic: true, optional: true

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, if: :password_required?
  validates :userable, presence: true
  validates :role, presence: true
  validate  :userable_presence_check, if: -> { persisted? && userable.present? }

  # Callback to ensure userable is present after creation
  after_create :ensure_userable_association

  # ✅ Required by Ransack for ActiveAdmin filtering/search
  def self.ransackable_attributes(_auth_object = nil)
    %w[id name email interest city birthdate number userable_id userable_type created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[userable]
  end

  private

  def password_required?
    new_record? || password.present?
  end

  def userable_presence_check
    if userable.blank?
      errors.add(:userable, "must be linked after registration")
    end
  end

  # Callback method to check if userable is present
  def ensure_userable_association
    if userable.nil?
      errors.add(:userable, "must be linked after registration")
      raise ActiveRecord::Rollback # To prevent user creation without userable association
    end
  end
end
