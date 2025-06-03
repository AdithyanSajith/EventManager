require 'rails_helper'

RSpec.describe Event, type: :model do
  it 'is valid with valid attributes' do
    expect(build(:event)).to be_valid
  end

  it 'is invalid without title' do
    expect(build(:event, title: nil)).not_to be_valid
  end

  it 'is invalid without description' do
    expect(build(:event, description: nil)).not_to be_valid
  end

  it 'is invalid without starts_at' do
    expect(build(:event, starts_at: nil)).not_to be_valid
  end

  it 'is invalid without ends_at' do
    expect(build(:event, ends_at: nil)).not_to be_valid
  end

  it 'is invalid if ends_at is before starts_at' do
    expect(build(:event, starts_at: 2.days.from_now, ends_at: 1.day.from_now)).not_to be_valid
  end

  it 'is invalid if starts_at is in the past' do
    expect(build(:event, starts_at: 1.day.ago)).not_to be_valid
  end

  it 'normalizes title before validation' do
    event = build(:event, title: '  test event  ')
    event.valid?
    expect(event.title).to eq('Test Event')
  end

  # Add more edge cases as needed
end
