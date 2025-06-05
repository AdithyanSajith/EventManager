require 'rails_helper'

RSpec.describe PaymentsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let!(:user) { create(:user, :participant) }
  let!(:event) { create(:event) }
  let!(:registration) { create(:registration, event: event) }
  let!(:payment) { create(:payment, registration: registration) }

  before do
    sign_in user
    allow(controller).to receive(:current_resource_owner).and_return(user)
  end

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index, params: { event_id: event.id }
      puts response.body unless response.successful?
      expect(response).to be_successful
    end

    it 'assigns all payments to @payments' do
      get :index, params: { event_id: event.id }
      expect(assigns(:payments)).to include(payment)
    end
  end

  describe 'GET #show' do
    it 'returns a successful response' do
      get :show, params: { event_id: event.id, id: payment.id }
      puts response.body unless response.successful?
      expect(response).to be_successful
    end

    it 'assigns the requested payment to @payment' do
      get :show, params: { event_id: event.id, id: payment.id }
      expect(assigns(:payment)).to eq(payment)
    end
  end

  describe 'POST #create' do
    let(:valid_attributes) do
      {
        registration_id: registration.id,
        amount: 150.0,
        card_number: '4111111111111111',
        paid_at: Time.current
      }
    end

    it 'creates a new payment with valid attributes' do
      expect {
        post :create, params: { event_id: event.id, payment: valid_attributes }
      }.to change(Payment, :count).by(1)
    end

    it 'does not create a payment with invalid attributes' do
      expect {
        post :create, params: { event_id: event.id, payment: valid_attributes.merge(amount: nil) }
      }.not_to change(Payment, :count)
    end
  end

  describe 'PATCH #update' do
    it 'updates the payment with valid attributes' do
      patch :update, params: { event_id: event.id, id: payment.id, payment: { amount: 200.0 } }
      payment.reload
      expect(payment.amount).to eq(200.0)
    end

    it 'does not update the payment with invalid attributes' do
      patch :update, params: { event_id: event.id, id: payment.id, payment: { amount: nil } }
      payment.reload
      expect(payment.amount).not_to eq(nil)
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the payment' do
      expect {
        delete :destroy, params: { event_id: event.id, id: payment.id }
      }.to change(Payment, :count).by(-1)
    end

    it 'redirects to payments index after destroy' do
      delete :destroy, params: { event_id: event.id, id: payment.id }
      expect(response).to redirect_to(payments_path)
    end
  end
end