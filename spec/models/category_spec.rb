require 'rails_helper'

RSpec.describe Category, type: :model do
  it 'is valid with valid attributes' do
    expect(build(:category)).to be_valid
  end

  it 'is invalid without a name' do
    expect(build(:category, name: nil)).not_to be_valid
  end

  it 'is invalid with a duplicate name' do
    create(:category, name: 'Music')
    expect(build(:category, name: 'Music')).not_to be_valid
  end

  # Add more edge cases as needed
end
