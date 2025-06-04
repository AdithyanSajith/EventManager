require 'rails_helper'

RSpec.describe ParticipantsController, type: :controller do
  let!(:participant) { create(:participant) }

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns all participants to @participants' do
      get :index
      expect(assigns(:participants)).to include(participant)
    end
  end

  describe 'GET #show' do
    it 'returns a successful response' do
      get :show, params: { id: participant.id }
      expect(response).to be_successful
    end

    it 'assigns the requested participant to @participant' do
      get :show, params: { id: participant.id }
      expect(assigns(:participant)).to eq(participant)
    end
  end

  # Add more specs for create, update, destroy, etc. as needed
end