require 'rails_helper'

RSpec.describe ParticipantsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let!(:participant_user) { create(:user, :participant) }
  let!(:participant) { participant_user.userable }

  before do
    sign_in participant_user
    allow(controller).to receive(:current_resource_owner).and_return(participant_user)
  end

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      puts response.body unless response.successful?
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
      puts response.body unless response.successful?
      expect(response).to be_successful
    end

    it 'assigns the requested participant to @participant' do
      get :show, params: { id: participant.id }
      expect(assigns(:participant)).to eq(participant)
    end
  end

  describe 'POST #create' do
    let(:valid_attributes) { attributes_for(:participant) }
    let(:invalid_attributes) { { name: nil } }

    it 'creates a new participant with valid attributes' do
      expect {
        post :create, params: { participant: valid_attributes }
      }.to change(Participant, :count).by(1)
    end

    it 'does not create a participant with invalid attributes' do
      expect {
        post :create, params: { participant: invalid_attributes }
      }.not_to change(Participant, :count)
    end
  end

  describe 'PATCH #update' do
    let(:new_name) { "Updated Name" }

    it 'updates the participant with valid attributes' do
      patch :update, params: { id: participant.id, participant: { name: new_name } }
      participant.reload
      expect(participant.name).to eq(new_name)
    end

    it 'does not update the participant with invalid attributes' do
      patch :update, params: { id: participant.id, participant: { name: nil } }
      participant.reload
      expect(participant.name).not_to eq(nil)
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the participant' do
      expect {
        delete :destroy, params: { id: participant.id }
      }.to change(Participant, :count).by(-1)
    end
  end
end