class Host < ApplicationRecord
  has_one :user, as: :userable, dependent: :destroy
  has_many :events, foreign_key: :host_id, dependent: :destroy
  has_many :venues, foreign_key: :host_id, dependent: :destroy

  validates :organisation, :website, :number, presence: true
  validates :bio, presence: true
  validates :number, numericality: { only_integer: true }, length: { is: 10 }

  before_validation :set_default_bio

  def self.ransackable_attributes(auth_object = nil)
    %w[id bio organisation website number created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user events venues]
  end

  def to_s
    organisation
  end

  private

  def set_default_bio
    self.bio ||= 'No bio provided.'
  end
end