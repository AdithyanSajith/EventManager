FactoryBot.define do
  factory :participant do
    name { "Test Participant" }
    city { "Test City" }
    interest { "Music" }
    birthdate { Date.today - 20.years }
  end
end
