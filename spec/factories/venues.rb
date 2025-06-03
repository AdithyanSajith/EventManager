FactoryBot.define do
  factory :venue do
    name { "Test Venue" }
    address { "123 Test St" }
    city { "Test City" }
    capacity { 100 }
    location { "Test Location" }
    association :host
  end
end
