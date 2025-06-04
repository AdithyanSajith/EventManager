require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  let!(:host) { create(:user, :host) }
  let!(:participant) { create(:user, :participant) }
  let!(:event) { create(:event, host: host.userable) }

  describe 'GET #index' do
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
      expect(response).to be_successful
      expect(assigns(:event)).to eq(event)
    end

    it 'shows registration info for logged-in participant' do
      sign_in participant
      get :show, params: { id: event.id }
      expect(response).to be_successful
      # Add more expectations for registration/payment/ticket info here
    end
  end

  describe 'POST #create' do
    it 'creates a new event as host' do
      sign_in host
      expect {
        post :create, params: { event: attributes_for(:event, host: host.userable) }
      }.to change(Event, :count).by(1)
    end

    it 'does not allow participant to create event' do
      sign_in participant
      expect {
        post :create, params: { event: attributes_for(:event, host: participant.userable) }
      }.not_to change(Event, :count)
    end
  end

  describe 'PATCH #update' do
    it 'updates the event as host' do
      sign_in host
      patch :update, params: { id: event.id, event: { title: 'Updated Title' } }
      event.reload
      expect(event.title).to eq('Updated Title')
    end

    it 'does not update the event as participant' do
      sign_in participant
      patch :update, params: { id: event.id, event: { title: 'Hacked Title' } }
      event.reload
      expect(event.title).not_to eq('Hacked Title')
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the event as host' do
      sign_in host
      expect {
        delete :destroy, params: { id: event.id }
      }.to change(Event, :count).by(-1)
    end

    it 'does not allow participant to delete event' do
      sign_in participant
      expect {
        delete :destroy, params: { id: event.id }
      }.not_to change(Event, :count)
    end
  end
end
