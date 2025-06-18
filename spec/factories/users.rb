FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password" }
    role { "participant" }
    association :userable, factory: :participant

    trait :host do
      association :userable, factory: :host
      role { "host" }
      userable_type { "Host" }
    end

    trait :participant do
      association :userable, factory: :participant
    end
  end
end