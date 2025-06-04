require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid with valid attributes' do
    expect(build(:user)).to be_valid
  end

  it 'is invalid without an email' do
    expect(build(:user, email: nil)).not_to be_valid
  end

  it 'is invalid without a password' do
    expect(build(:user, password: nil)).not_to be_valid
  end

  it 'is invalid without a role' do
    expect(build(:user, role: nil)).not_to be_valid
  end

  it 'requires a unique email' do
    create(:user, email: 'test@example.com')
    expect(build(:user, email: 'test@example.com')).not_to be_valid
  end

  it 'can be a host or participant' do
    expect(build(:user, role: 'host')).to be_valid
    expect(build(:user, role: 'participant')).to be_valid
  end

  it 'is invalid with a short password' do
    expect(build(:user, password: '123')).not_to be_valid
  end

  it 'requires userable to be present after creation' do
    user = build(:user)
    user.userable = nil
    user.save
    expect(user.errors[:userable]).to be_present
  end
  
end
