require 'rails_helper'

RSpec.describe Review, type: :model do
  it 'is valid with valid attributes' do
    expect(build(:review)).to be_valid
  end

  it 'is invalid without a participant' do
    expect(build(:review, participant: nil)).not_to be_valid
  end

  it 'is invalid without a reviewable' do
    expect(build(:review, reviewable: nil)).not_to be_valid
  end

  it 'is invalid with duplicate review for same item' do
    review = create(:review)
    expect(build(:review, participant: review.participant, reviewable: review.reviewable)).not_to be_valid
  end

  # Add more edge cases as needed
end
