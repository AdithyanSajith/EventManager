require 'rails_helper'

RSpec.describe Registration, type: :model do
  it 'is valid with valid attributes' do
    expect(build(:registration)).to be_valid
  end

  it 'is invalid without a participant' do
    expect(build(:registration, participant: nil)).not_to be_valid
  end

  it 'is invalid without an event' do
    expect(build(:registration, event: nil)).not_to be_valid
  end

  it 'creates a ticket after registration' do
    registration = create(:registration)
    expect(registration.ticket).to be_present
  end

  it 'can have a payment associated' do
    registration = create(:registration)
    payment = create(:payment, registration: registration, amount: 100.0)
    expect(registration.payment).to eq(payment)
    expect(payment.amount).to eq(100.0)
  end

end
