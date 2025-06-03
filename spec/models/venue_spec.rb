require 'rails_helper'

RSpec.describe Venue, type: :model do
  it 'is valid with valid attributes' do
    expect(build(:venue)).to be_valid
  end

  it 'is invalid without a name' do
    expect(build(:venue, name: nil)).not_to be_valid
  end

  it 'is invalid without an address' do
    expect(build(:venue, address: nil)).not_to be_valid
  end

  it 'is invalid without a city' do
    expect(build(:venue, city: nil)).not_to be_valid
  end

  it 'is invalid without a capacity' do
    expect(build(:venue, capacity: nil)).not_to be_valid
  end

  it 'is invalid with negative capacity' do
    expect(build(:venue, capacity: -10)).not_to be_valid
  end

  # Add more edge cases as needed
end
