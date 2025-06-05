FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password" }
    role { "participant" }
    association :userable, factory: :participant

    trait :host do
      role { "host" }
      association :userable, factory: :host
    end

    trait :participant do
      role { "participant" }
      association :userable, factory: :participant
    end
  end
end