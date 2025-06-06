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

  # Association tests
  describe "associations" do
    it "belongs to a host" do
      association = Venue.reflect_on_association(:host)
      expect(association.macro).to eq(:belongs_to)
    end

    it "has many events" do
      association = Venue.reflect_on_association(:events)
      expect(association.macro).to eq(:has_many)
    end

    it "has many reviews as a reviewable" do
      association = Venue.reflect_on_association(:reviews)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:as]).to eq(:reviewable)
    end
  end  # Test events are protected
  describe "dependent events" do
    it "has events that prevent deletion" do
      host = create(:host)
      venue = create(:venue, host: host)
      create(:event, venue: venue, host: host, category: create(:category))
      
      expect { venue.destroy rescue nil }.not_to change(Venue, :count)
    end
    
    it "allows deletion when no events exist" do
      venue = create(:venue)
      
      expect { venue.destroy }.to change(Venue, :count).by(-1)
    end
  end
  # Review-related functionality
  describe "reviews" do
    let(:venue) { create(:venue) }
    let(:participant) { create(:participant) }

    it "has reviews as a polymorphic association" do
      review = create(:review, reviewable: venue, participant: participant, rating: 4)
      expect(venue.reviews).to include(review)
    end

    it "calculates the correct average rating" do
      create(:review, reviewable: venue, participant: participant, rating: 3)
      create(:review, reviewable: venue, participant: create(:participant), rating: 5)
      
      expect(venue.reviews.average(:rating).to_f).to eq(4.0)
    end
  end
end
