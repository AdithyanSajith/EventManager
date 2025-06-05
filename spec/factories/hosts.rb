FactoryBot.define do
  factory :host do
    organisation { "Test Org" }
    website { "https://test.org" }
    bio { "Test bio" }
    sequence(:number) { |n| "12345678#{format('%02d', n % 100)}" } # Ensure 10 digits and uniqueness
  end
end
