require 'rails_helper'

RSpec.describe Payment, type: :model do
  it 'is valid with valid attributes' do
    expect(build(:payment)).to be_valid
  end

  it 'is invalid without a registration' do
    expect(build(:payment, registration: nil)).not_to be_valid
  end

  it 'is invalid with negative amount' do
    expect(build(:payment, amount: -100)).not_to be_valid
  end

  # Add more edge cases as needed
end
