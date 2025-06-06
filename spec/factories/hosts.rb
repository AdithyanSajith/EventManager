FactoryBot.define do
  factory :host do
    organisation { "Test Org" }
    website { "https://test.org" }
    number { "1234567890" }
    bio { "Test bio" }
  end
end
