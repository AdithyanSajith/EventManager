require 'rails_helper'

RSpec.describe PaymentsController, type: :controller do
  include Devise::Test::ControllerHelpers
  
  let(:participant_user) { create(:user, :participant) }
  let(:event) { create(:event) }
  let(:registration) { create(:registration, event: event, participant: participant_user.userable) }
  let(:payment) { create(:payment, registration: registration) }
  
  before { sign_in participant_user }

  describe "authorization" do
    it "redirects hosts to root path" do
      host_user = create(:user, :host)
      sign_in host_user
      
      get :new, params: { event_id: event.id }
      expect(response).to redirect_to(root_path)
      expect(Array(flash[:alert] || flash[:error])).to include("Only participants can make payments.")
    end
  end
  
  describe "GET #new" do
    it "creates a registration if one doesn't exist" do
      expect {
        get :new, params: { event_id: event.id }
      }.to change(Registration, :count).by(1)
    end
    
    it "does not create a duplicate registration" do
      registration # Create registration by referencing the let variable
      
      expect {
        get :new, params: { event_id: event.id }
      }.not_to change(Registration, :count)
    end
  end
  
  describe "error handling" do
    it "handles ActiveRecord::RecordNotFound" do
      get :show, params: { event_id: event.id, id: 999999 }
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("Payment not found.")
    end
  end
end
