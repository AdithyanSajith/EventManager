require 'rails_helper'

RSpec.describe Participant, type: :model do
  it 'is valid with valid attributes' do
    expect(build(:participant)).to be_valid
  end

  it 'is invalid without name' do
    expect(build(:participant, name: nil)).not_to be_valid
  end

  it 'is invalid without city' do
    expect(build(:participant, city: nil)).not_to be_valid
  end

  it 'is invalid without interest' do
    expect(build(:participant, interest: nil)).not_to be_valid
  end

  it 'is invalid without birthdate' do
    expect(build(:participant, birthdate: nil)).not_to be_valid
  end

  it 'is invalid with too long interest' do
    expect(build(:participant, interest: 'a' * 301)).not_to be_valid
  end

  it 'is invalid with too long city' do
    expect(build(:participant, city: 'a' * 101)).not_to be_valid
  end

  it 'sets default interest if missing' do
    participant = build(:participant, interest: nil)
    participant.save
    expect(participant.interest).not_to be_nil
  end

  # Add more edge cases as needed
end
