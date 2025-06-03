FactoryBot.define do
  factory :registration do
    association :participant
    association :event
    status { "confirmed" }
  end
end
