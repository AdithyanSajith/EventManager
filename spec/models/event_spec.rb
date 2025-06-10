require 'rails_helper'

RSpec.describe Event, type: :model do
  it 'is valid with valid attributes' do
    host = create(:host)
    category = create(:category)
    venue = create(:venue, host: host)
    event = build(:event, host: host, category: category, venue: venue)
    expect(event).to be_valid
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

  # Association tests
  describe "associations" do
    it "belongs to a host" do
      association = Event.reflect_on_association(:host)
      expect(association.macro).to eq(:belongs_to)
    end

    it "belongs to a venue" do
      association = Event.reflect_on_association(:venue)
      expect(association.macro).to eq(:belongs_to)
    end

    it "belongs to a category" do
      association = Event.reflect_on_association(:category)
      expect(association.macro).to eq(:belongs_to)
    end

    it "has many registrations" do
      association = Event.reflect_on_association(:registrations)
      expect(association.macro).to eq(:has_many)
    end

    it "has many participants through registrations" do
      association = Event.reflect_on_association(:participants)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:through]).to eq(:registrations)
    end
    
    it "has many reviews as a reviewable" do
      association = Event.reflect_on_association(:reviews)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:as]).to eq(:reviewable)
    end
  end

  # Callback tests
  describe "callbacks" do
    it "normalizes title before validation" do
      event = build(:event, title: "my awesome event")
      event.valid?
      expect(event.title).to eq("My Awesome Event")
    end
  end

  # Method tests
  describe "#average_rating" do
    let(:host) { create(:host) }
    let(:category) { create(:category) }
    let(:venue) { create(:venue) }
    let(:event) { create(:event, host: host, category: category, venue: venue) }
    let(:participant) { create(:participant) }

    it "returns 0.0 when there are no reviews" do
      expect(event.average_rating).to eq(0.0)
    end

    it "calculates the average rating from reviews" do
      create(:review, reviewable: event, participant: participant, rating: 4)
      create(:review, reviewable: event, participant: create(:participant), rating: 5)
      expect(event.average_rating).to eq(4.5)
    end
  end

  describe "#check_for_registrations" do
    let(:host) { create(:host) }
    let(:category) { create(:category) }
    let(:venue) { create(:venue) }
    let(:event) { create(:event, host: host, category: category, venue: venue) }
    let(:participant) { create(:participant) }
    
    it "has registrations that can be accessed" do
      reg = create(:registration, event: event, participant: participant)
      expect(event.registrations).to include(reg)
    end

    it "allows deletion if no registrations exist" do
      event_id = event.id
      event.destroy
      expect(Event.exists?(event_id)).to eq(false)
    end
  end
end
