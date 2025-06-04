require 'rails_helper'

RSpec.describe RegistrationsController, type: :controller do
  let!(:participant) { create(:participant) } # let ensures the participant is created before tests run
  let!(:event) { create(:event) }
  let!(:registration) { create(:registration, participant: participant, event: event) } # Links reg with participant and event

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns all registrations to @registrations' do
      get :index
      expect(assigns(:registrations)).to include(registration)
    end
  end

  describe 'GET #show' do
    it 'returns a successful response' do
      get :show, params: { id: registration.id }
      expect(response).to be_successful
    end
    
    it 'assigns the requested registration to @registration' do
      get :show, params: { id: registration.id }
      expect(assigns(:registration)).to eq(registration)
    end
  end
end