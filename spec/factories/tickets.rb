FactoryBot.define do
  factory :ticket do
    association :registration
    ticket_number { SecureRandom.hex(6).upcase }
    issued_at { Time.current }
  end
end
