require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  include Devise::Test::ControllerHelpers

  let!(:user) { create(:user) }

  before { sign_in user }

  describe "GET #show" do
    it "returns a successful response" do
      get :show, params: { id: user.id }
      expect(response).to be_successful
      expect(assigns(:user)).to eq(user)
    end
  end
end