require 'rails_helper'

RSpec.describe PaymentsController, type: :controller do
  let!(:payment) { create(:payment) }

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns all payments to @payments' do
      get :index
      expect(assigns(:payments)).to include(payment)
    end
  end

  describe 'GET #show' do
    it 'returns a successful response' do
      get :show, params: { id: payment.id }
      expect(response).to be_successful
    end

    it 'assigns the requested payment to @payment' do
      get :show, params: { id: payment.id }
      expect(assigns(:payment)).to eq(payment)
    end
  end

  describe 'POST #create' do
    let(:registration) { create(:registration) }
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
        post :create, params: { payment: valid_attributes }
      }.to change(Payment, :count).by(1)
    end

    it 'does not create a payment with invalid attributes' do
      expect {
        post :create, params: { payment: valid_attributes.merge(amount: nil) }
      }.not_to change(Payment, :count)
    end
  end

  describe 'PATCH #update' do
    it 'updates the payment with valid attributes' do
      patch :update, params: { id: payment.id, payment: { amount: 200.0 } }
      payment.reload
      expect(payment.amount).to eq(200.0)
    end

    it 'does not update the payment with invalid attributes' do
      patch :update, params: { id: payment.id, payment: { amount: nil } }
      payment.reload
      expect(payment.amount).not_to eq(nil)
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the payment' do
      expect {
        delete :destroy, params: { id: payment.id }
      }.to change(Payment, :count).by(-1)
    end

    it 'redirects to payments index after destroy' do
      delete :destroy, params: { id: payment.id }
      expect(response).to redirect_to(payments_path)
    end
  end
end