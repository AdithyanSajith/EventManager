class User < ApplicationRecord
  # 👤 Devise authentication modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # ===========================
  # 🔗 ASSOCIATIONS
  # ===========================

  # Hosted events (for hosts only)
  has_many :events, foreign_key: :host_id, dependent: :destroy

  # Hosted venues (for hosts only)
  has_many :venues, foreign_key: :host_id, dependent: :destroy, inverse_of: :host

  # Event registrations (for participants only)
  has_many :registrations, foreign_key: :participant_id, dependent: :destroy

  # Events the participant registered for
  has_many :registered_events, through: :registrations, source: :event

  # Tickets and payments through participant registrations
  has_many :tickets, through: :registrations
  has_many :payments, through: :registrations

  # ===========================
  # ✅ VALIDATIONS
  # ===========================

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, uniqueness: true
  validates :role, presence: true
  validates :password, length: { minimum: 6 }, if: :password_required?

  # 🎯 Host-specific validations
  with_options if: -> { role == "host" } do
    validates :organisation, :website, :bio, :number, presence: true
    validates :number, numericality: { only_integer: true }, length: { is: 10 }
  end

  # 🙋 Participant-specific validations
  with_options if: -> { role == "participant" } do
    validates :interest, :city, :birthdate, presence: true
    validates :interest, length: { maximum: 300 }
    validates :city, length: { maximum: 100 }
  end

  # ===========================
  # 🔍 ACTIVE ADMIN SUPPORT
  # ===========================

  def self.ransackable_attributes(auth_object = nil)
    %w[
      id name email role city interest birthdate
      organisation website created_at updated_at
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[
      events venues registrations registered_events
      tickets payments
    ]
  end

  private

  # Required by Devise to avoid validation error on update without changing password
  def password_required?
    new_record? || password.present?
  end
end
