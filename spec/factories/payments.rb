FactoryBot.define do
  factory :payment do
    association :registration
    amount { 100.0 }
    card_number { '4111111111111111' }
    paid_at { Time.current }
  end
end
