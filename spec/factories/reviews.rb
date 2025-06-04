FactoryBot.define do
  factory :review do
    rating { 5 }
    comment { "Great event!" }
    association :participant
    association :reviewable, factory: :event
  end
end
