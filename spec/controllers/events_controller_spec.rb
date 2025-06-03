require 'rails_helper'

describe EventsController, type: :controller do
  let!(:host) { create(:user, :host) }
  let!(:participant) { create(:user, :participant) }
  let!(:event) { create(:event, host: host.userable) }

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
      # You can add more expectations for registration/payment/ticket info here
    end
  end
end
