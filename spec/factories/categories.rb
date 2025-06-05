FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "Music#{n}" } # Ensure uniqueness for tests
  end
end
