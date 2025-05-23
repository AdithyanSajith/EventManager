class User < ApplicationRecord
  belongs_to :userable, polymorphic: true, optional: true

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, if: :password_required?
  validates :role, presence: true

  private

  def password_required?
    new_record? || password.present?
  end
end
