require 'rails_helper'

RSpec.describe Participant, type: :model do
  describe "associations" do
    it "has many registrations" do
      association = Participant.reflect_on_association(:registrations)
      expect(association.macro).to eq(:has_many)
    end

    it "has many events through registrations" do
      association = Participant.reflect_on_association(:events)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:through]).to eq(:registrations)
    end

    it "has many reviews" do
      association = Participant.reflect_on_association(:reviews)
      expect(association.macro).to eq(:has_many)
    end
  end

  describe "virtual attributes" do
    it "can receive events through registrations" do
      participant = create(:participant)
      event = create(:event)
      create(:registration, event: event, participant: participant)
      
      expect(participant.events).to include(event)
    end
  end
end
