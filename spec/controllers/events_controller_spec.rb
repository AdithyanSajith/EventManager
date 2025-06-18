require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let!(:host_user) { create(:user, :host) }
  let!(:participant_user) { create(:user, :participant) }
  let!(:venue) { create(:venue, host: host_user.userable) }
  let!(:category) { create(:category) }
  let!(:event) { create(:event, host: host_user.userable, venue: venue, category: category) }

  describe 'GET #index' do
    before { sign_in host_user }

    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns all events to @events' do
      get :index
      expect(assigns(:events)).to include(event)
    end
  end

  describe 'GET #show' do
    it 'allows guests to view event details' do
      get :show, params: { id: event.id }
      puts "Response status: ", response.status
      puts "Response body: ", response.body
      expect(response).to be_successful
      expect(assigns(:event)).to eq(event)
    end

    it 'shows registration info for logged-in participant' do
      sign_in participant_user
      get :show, params: { id: event.id }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    it 'creates a new event as host' do
      sign_in host_user
      expect {
        post :create, params: { event: attributes_for(:event).merge(
          host_id: host_user.userable.id,
          venue_id: venue.id,
          category_id: category.id
        ) }
      }.to change(Event, :count).by(1)
    end

    it 'does not allow participant to create event' do
      sign_in participant_user
      expect {
        post :create, params: { event: attributes_for(:event).merge(
          host_id: participant_user.userable.id,
          venue_id: venue.id,
          category_id: category.id
        ) }
      }.not_to change(Event, :count)
    end
  end

  describe 'PATCH #update' do
    it 'updates the event as host' do
      sign_in host_user
      patch :update, params: { id: event.id, event: { title: 'Updated Title' } }
      event.reload
      expect(event.title).to eq('Updated Title')
    end

    it 'does not update the event as participant' do
      sign_in participant_user
      patch :update, params: { id: event.id, event: { title: 'Hacked Title' } }
      event.reload
      expect(event.title).not_to eq('Hacked Title')
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the event as host' do
      sign_in host_user
      expect {
        delete :destroy, params: { id: event.id }
      }.to change(Event, :count).by(-1)
    end

    it 'does not allow participant to delete event' do
      sign_in participant_user
      expect {
        delete :destroy, params: { id: event.id }
      }.not_to change(Event, :count)
    end
  end
end
