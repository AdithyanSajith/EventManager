class AdminUser < ApplicationRecord
  # Include only the Devise modules you are using
  devise :database_authenticatable, 
         :recoverable, 
         :rememberable, 
         :validatable

  # ✅ Explicitly whitelist searchable attributes for Ransack (used by ActiveAdmin filters)
  def self.ransackable_attributes(auth_object = nil)
    %w[id email created_at updated_at]
  end
end
