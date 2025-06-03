FactoryBot.define do
  factory :host do
    organisation { "Test Org" }
    website { "https://test.org" }
    bio { "Test bio" }
    number { "1234567890" }
  end
end
