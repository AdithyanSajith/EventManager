class User < ApplicationRecord
  # Hosted events (for hosts)
  has_many :events, foreign_key: :host_id, dependent: :destroy

  # Hosted venues (for hosts)
  has_many :venues, foreign_key: :host_id, dependent: :destroy, inverse_of: :host

  # Participant event registrations
  has_many :registrations, foreign_key: :participant_id, dependent: :destroy
  has_many :registered_events, through: :registrations, source: :event

  # Tickets and payments through registrations
  has_many :tickets, through: :registrations
  has_many :payments, through: :registrations

  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Validations
  validates :name, presence: true, length: { maximum: 50 }
  validates :role, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, if: :password_required?

  with_options if: -> { role == "host" } do
    validates :organisation, :website, :bio, :number, presence: true
    validates :number, numericality: { only_integer: true }, length: { is: 10 }
  end

  with_options if: -> { role == "participant" } do
    validates :interest, :city, :birthdate, presence: true
    validates :interest, length: { maximum: 300 }
    validates :city, length: { maximum: 100 }
  end

  # ✅ Allow only safe attributes to be used in ActiveAdmin filters
  def self.ransackable_attributes(auth_object = nil)
    %w[id name email role city interest birthdate organisation website created_at updated_at]
  end

  # ✅ Allow only safe associations to be used in ActiveAdmin filters
  def self.ransackable_associations(auth_object = nil)
    %w[events venues registrations registered_events tickets payments]
  end

  private

  def password_required?
    new_record? || password.present?
  end
end
