FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password" }
    association :userable, factory: :participant

    trait :host do
      association :userable, factory: :host
    end

    trait :participant do
      association :userable, factory: :participant
    end
  end
end