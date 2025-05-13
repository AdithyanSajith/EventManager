class Host < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :events
  has_many :managed_events
  has_many :venues, dependent: :destroy  # ✅ THIS LINE is critical
end
