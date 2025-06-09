require 'rails_helper'

describe 'Events API', type: :request do
  let!(:events) { create_list(:event, 3) }

  it 'returns a list of events' do
    get '/api/v1/events'
    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body).length).to eq(3)
  end
end
