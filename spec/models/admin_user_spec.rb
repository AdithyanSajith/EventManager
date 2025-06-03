require 'rails_helper'

RSpec.describe AdminUser, type: :model do
  it 'is valid with valid attributes' do
    expect(build(:admin_user)).to be_valid
  end

  it 'is invalid without an email' do
    expect(build(:admin_user, email: nil)).not_to be_valid
  end

  it 'is invalid without a password' do
    expect(build(:admin_user, password: nil)).not_to be_valid
  end

  it 'requires a unique email' do
    create(:admin_user, email: 'admin@example.com')
    expect(build(:admin_user, email: 'admin@example.com')).not_to be_valid
  end

  # Add more edge cases as needed
end
