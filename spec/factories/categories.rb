FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "Test Category #{n}" }
  end
end
