class ParticipantsController < ApplicationController
  # Use Devise's authenticate_user! for web-based authentication
  before_action :authenticate_user!
  before_action :authorize_participant!

  def choose_category
    @categories = Category.all
  end

  def set_preference
    if current_resource_owner.update(interest: params[:interest])
      redirect_to filtered_events_path, notice: "Category preference saved!"
    else
      redirect_to choose_category_path, alert: "Something went wrong."
    end
  end

  def change_category
    @categories = Category.all
  end

  def update_interest
    if current_resource_owner.update(interest: params[:interest])
      redirect_to filtered_events_path, notice: "Interest updated!"
    else
      redirect_to change_category_path, alert: "Update failed."
    end
  end

  def profile
    @participant = current_resource_owner
  end

  private

  # Ensure the user is a participant
  def authorize_participant!
    unless current_resource_owner.role == "participant"
      redirect_to root_path, alert: "Only participants can access this page."
    end
  end
end
