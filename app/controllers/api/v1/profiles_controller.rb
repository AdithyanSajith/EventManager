module Api
  module V1
    class ProfilesController < ApplicationController
      before_action :authenticate_resource_owner!
      respond_to :json

      def show
        render json: current_resource_owner.as_json(
          only: [:id, :email, :name, :role],
          include: {
            userable: { except: [:created_at, :updated_at] }
          }
        ), status: :ok
      end

      def update
        if current_resource_owner.update(user_params)
          render json: { message: "Profile updated." }, status: :ok
        else
          render json: { errors: current_resource_owner.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(:name, :email, userable_attributes: [:organisation, :website, :bio, :number])
      end

      # Combined auth supporting OAuth token or Devise session
      def authenticate_resource_owner!
        if doorkeeper_token
          doorkeeper_authorize!
        else
          authenticate_user!
        end
      end

      def current_resource_owner
        if doorkeeper_token
          User.find(doorkeeper_token.resource_owner_id)
        else
          current_user
        end
      end
      helper_method :current_resource_owner
    end
  end
end
