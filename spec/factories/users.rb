FactoryBot.define do
  factory :user do
    email { "user@example.com" }
    password { "password123" }
    role { "participant" }
    name { "Test User" }
    interest { "Music" }
    city { "Test City" }
    birthdate { Date.today - 20.years }
    number { "1234567890" }
    organisation { "Test Org" }
    website { "https://test.org" }
    bio { "Test bio" }
    association :userable, factory: :participant
  end
end
