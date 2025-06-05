require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let!(:user) { create(:user) }
  let!(:review) { create(:review) }

  before { sign_in user }

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns all reviews to @reviews' do
      get :index
      expect(assigns(:reviews)).to include(review)
    end
  end

  describe 'GET #show' do
    it 'returns a successful response' do
      get :show, params: { id: review.id }
      expect(response).to be_successful
    end

    it 'assigns the requested review to @review' do
      get :show, params: { id: review.id }
      expect(assigns(:review)).to eq(review)
    end
  end
end