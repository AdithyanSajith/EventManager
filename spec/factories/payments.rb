FactoryBot.define do
  factory :payment do
    amount { 100 }
    card_number { "4111111111111111" }
    status { "paid" }
    paid_at { Time.current }
    association :registration
  end
end
