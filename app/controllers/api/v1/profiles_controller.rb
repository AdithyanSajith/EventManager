module Api
  module V1
    class ProfilesController < ApplicationController
      before_action :authenticate_user!
      respond_to :json

      def show
        render json: current_user.as_json(
          only: [:id, :email, :name, :role],
          include: {
            userable: {
              except: [:created_at, :updated_at]
            }
          }
        )
      end

      def update
        if current_user.update(user_params)
          render json: { message: "Profile updated." }
        else
          render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(
          :name, :email,
          userable_attributes: [:organisation, :website, :bio, :number]
        )
      end
    end
  end
end
