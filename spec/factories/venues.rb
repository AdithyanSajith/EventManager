FactoryBot.define do
  factory :venue do
    sequence(:name) { |n| "Venue #{n}" }
    address { "123 Test St" }
    city { "Test City" }
    capacity { 100 }
    location { "Test Location" }
    association :host
  end
end
