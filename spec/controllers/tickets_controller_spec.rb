require 'rails_helper'

RSpec.describe TicketsController, type: :controller do
  include Devise::Test::ControllerHelpers
  let!(:participant_user) { create(:user, :participant) }
  let!(:event) { create(:event) }
  let!(:registration) { create(:registration, participant: participant_user.userable, event: event) }
  let!(:ticket) { create(:ticket, registration: registration) }

  before { sign_in participant_user }

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns all tickets to @tickets' do
      get :index
      expect(assigns(:tickets)).to include(ticket)
    end
  end

  describe 'GET #show' do
    it 'returns a successful response' do
      get :show, params: { id: ticket.id }
      expect(response).to be_successful
    end

    it 'assigns the requested ticket to @ticket' do
      get :show, params: { id: ticket.id }
      expect(assigns(:ticket)).to eq(ticket)
    end
  end

  # Add more specs for create, update, destroy, etc. as needed
end