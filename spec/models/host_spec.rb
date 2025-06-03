require 'rails_helper'

RSpec.describe Host, type: :model do
  it 'is valid with valid attributes' do
    expect(build(:host)).to be_valid
  end

  it 'is invalid without organisation' do
    expect(build(:host, organisation: nil)).not_to be_valid
  end

  it 'is invalid without website' do
    expect(build(:host, website: nil)).not_to be_valid
  end

  it 'is invalid without bio' do
    expect(build(:host, bio: nil)).not_to be_valid
  end

  it 'is invalid without number' do
    expect(build(:host, number: nil)).not_to be_valid
  end

  it 'is invalid with non-integer number' do
    expect(build(:host, number: 'abc')).not_to be_valid
  end

  it 'is invalid with number not 10 digits' do
    expect(build(:host, number: 123)).not_to be_valid
    expect(build(:host, number: 123456789012)).not_to be_valid
  end

  it 'sets default bio if missing' do
    host = build(:host, bio: nil)
    host.save
    expect(host.bio).to eq('No bio provided.')
  end

  # Add more edge cases as needed
end
