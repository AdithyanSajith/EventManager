require 'rails_helper'

RSpec.describe VenuesController, type: :controller do
  include Devise::Test::ControllerHelpers

  let!(:host_user) { create(:user, :host) }
  let!(:venue) { create(:venue, host: host_user.userable) }

  before { sign_in host_user }

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns all venues to @venues' do
      get :index
      expect(assigns(:venues)).to include(venue)
    end
  end

  describe 'GET #show' do
    it 'shows venue details' do
      get :show, params: { id: venue.id }
      expect(response).to be_successful
      expect(assigns(:venue)).to eq(venue)
    end
  end

  describe 'POST #create' do
    it 'creates a new venue as host' do
      expect {
        post :create, params: { venue: attributes_for(:venue) }
      }.to change(Venue, :count).by(1)
    end
  end

  describe 'PATCH #update' do
    it 'updates the venue as host' do
      patch :update, params: { id: venue.id, venue: { name: 'Updated Venue' } }
      venue.reload
      expect(venue.name).to eq('Updated Venue')
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the venue as host' do
      expect {
        delete :destroy, params: { id: venue.id }
      }.to change(Venue, :count).by(-1)
    end
  end
end