module Api
  module V1
    class BaseController < ActionController::API
      before_action :doorkeeper_authorize!

      # Helper to get the current user from the token
      def current_resource_owner
        return unless doorkeeper_token
        @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id)
      end
    end
  end
end
