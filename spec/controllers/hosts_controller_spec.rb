require 'rails_helper'

RSpec.describe HostsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let!(:host_user) { create(:user, :host) }

  before { sign_in host_user }

  describe "GET #dashboard" do
    it "returns a successful response" do
      get :dashboard
      expect(response).to be_successful
    end
  end
end