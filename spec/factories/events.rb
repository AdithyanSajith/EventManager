FactoryBot.define do
  factory :event do
    title { "Sample Event" }
    description { "Sample event description" }
    starts_at { 2.days.from_now }
    ends_at { 3.days.from_now }
    association :host
    association :venue
    association :category
  end
end
