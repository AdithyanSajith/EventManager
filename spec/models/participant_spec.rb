require 'rails_helper'

RSpec.describe Participant, type: :model do
  it 'is valid with valid attributes' do
    expect(build(:participant)).to be_valid
  end

  it 'is invalid with too long interest' do
    expect(build(:participant, interest: 'a' * 100)).not_to be_valid
  end

  it 'is invalid with too long city' do
    expect(build(:participant, city: 'a' * 101)).not_to be_valid
  end

  it 'sets default interest if missing' do
    participant = build(:participant, interest: nil)
    participant.save
    expect(participant.interest).not_to be_nil
  end

  it 'is valid without interest (default is set)' do
    participant = build(:participant, interest: nil)
    expect(participant).to be_valid
    participant.save
    expect(participant.interest).to eq('No interest provided')
  end

  it 'is valid without name (default is set)' do
    participant = build(:participant, name: nil)
    expect(participant).to be_valid
    participant.save
    expect(participant.name).to eq('No name provided')
  end

  it 'is valid without city (default is set)' do
    participant = build(:participant, city: nil)
    expect(participant).to be_valid
    participant.save
    expect(participant.city).to eq('No city provided')
  end

  it 'is valid without birthdate (default is set)' do
    participant = build(:participant, birthdate: nil)
    expect(participant).to be_valid
    participant.save
    expect(participant.birthdate).to eq(Date.new(2000, 1, 1))
  end

end
