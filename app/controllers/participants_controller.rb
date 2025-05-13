class ParticipantsController < ApplicationController
  before_action :authenticate_participant!

  # Displays the list of categories to the participant
  def choose_category
    @categories = Category.all
  end

  # Sets the participant's category preference based on the selected interest
  def set_preference
    if current_participant.update(interest: params[:interest])
      redirect_to filtered_events_path, notice: "Category preference saved!"
    else
      redirect_to choose_category_path, alert: "Something went wrong."
    end
  end

  # Displays the change category form to the participant
  def change_category
    @categories = Category.all
  end

  # Updates the participant's interest based on the selection from the change category form
  def update_interest
    if current_participant.update(interest: params[:interest])
      redirect_to filtered_events_path, notice: "Interest updated!"
    else
      redirect_to change_category_path, alert: "Update failed."
    end
  end
end
