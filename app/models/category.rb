class Category < ApplicationRecord
  # ✅ Explicitly allow these fields to be searchable in ActiveAdmin filters
  def self.ransackable_attributes(auth_object = nil)
    %w[id name created_at updated_at]
  end
end
