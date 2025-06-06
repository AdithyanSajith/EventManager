require 'rails_helper'

RSpec.describe Ticket, type: :model do
  it 'is valid with valid attributes' do
    expect(build(:ticket)).to be_valid
  end

  it 'is invalid without a registration' do
    expect(build(:ticket, registration: nil)).not_to be_valid
  end
  it 'assigns a ticket number before create' do
    event = create(:event)
    participant = create(:participant)
    registration = create(:registration, event: event, participant: participant)
    ticket = build(:ticket, registration: registration, ticket_number: nil)
    ticket.save
    expect(ticket.ticket_number).not_to be_nil
  end

end
