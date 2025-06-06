require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:participant_user) { create(:user, :participant) }
  let(:event) { create(:event) }
  let(:review) { create(:review, reviewable: event, participant: participant_user.userable) }
  
  before { sign_in participant_user }

  describe "POST #create" do
    it "creates a new review for an event" do
      # Ensure registration and ticket exist for participant and event
      registration = create(:registration, event: event, participant: participant_user.userable)
      create(:ticket, registration: registration)
      expect {
        post :create, params: {
          event_id: event.id,
          review: {
            rating: 5,
            comment: "Great event!"
          }
        }
      }.to change(Review, :count).by(1)
      expect(Review.last.reviewable).to eq(event)
      expect(Review.last.participant).to eq(participant_user.userable)
    end
  end
  describe "DELETE #destroy" do
    it "allows a participant to delete their own review" do
      review # Create the review by referencing let variable
      
      expect {
        delete :destroy, params: { id: review.id }
      }.to change(Review, :count).by(-1)
    end
      it "redirects to reviews path after successful deletion" do
      review # Create the review by referencing let variable
      
      delete :destroy, params: { id: review.id }
      expect(response).to redirect_to(reviews_path)
    end
    
    it "shows success message after deletion" do
      review # Create the review by referencing let variable
      delete :destroy, params: { id: review.id }
      expect(flash[:notice] || flash[:success]).to be_present
    end
  end
end
