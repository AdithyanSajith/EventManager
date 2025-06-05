FactoryBot.define do
  factory :participant do
    sequence(:name) { |n| "Test Participant #{n}" }
    city { "Test City" }
    interest { "Music" }
    birthdate { Date.today - 20.years }
  end
end