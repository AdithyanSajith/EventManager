class ParticipantsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_participant!

  def index
    @participants = Participant.all
  end

  def show
    @participant = Participant.find(params[:id])
  end

  def create
    @participant = Participant.new(participant_params)
    if @participant.save
      redirect_to @participant
    else
      render :new
    end
  end

  def update
    @participant = Participant.find(params[:id])
    if @participant.update(participant_params)
      redirect_to @participant
    else
      render :edit
    end
  end

  def destroy
    @participant = Participant.find(params[:id])
    @participant.destroy
    redirect_to participants_path
  end

  # --- Your custom actions below ---
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
    if current_user.userable_type == "Participant" && current_user.userable.present?
      # Store the category name instead of ID
      category = Category.find_by(id: params[:interest])
      if category && current_user.userable.update(interest: category.name)
        redirect_to filtered_events_path, notice: "Interest updated!"
      else
        redirect_to change_category_path, alert: "Update failed."
      end
    else
      redirect_to root_path, alert: "Only participants can update interest."
    end
  end

  def profile
    if current_user&.userable_type == "Participant" && current_user.userable.present?
      @participant = current_user.userable
    else
      redirect_to root_path, alert: "Only participants can view this page." and return
    end
  end

  # Add this method so current_resource_owner works with Devise
  def current_resource_owner
    current_user
  end

  private

  # Ensure the user is a participant or an admin
  def authorize_participant!
    # Allow admin users automatic access (but do not allow them to view /profile)
    if current_user.is_a?(AdminUser)
      redirect_to root_path, alert: "Admins cannot access the participant profile page." and return
    end
    # For regular users, check for participant role
    unless current_user.is_a?(User) && current_user.userable_type == "Participant" && current_user.userable.present?
      redirect_to root_path, alert: "Only participants can access this page." and return
    end
  end

  def participant_params
    params.require(:participant).permit(:name, :interest, :city, :birthdate)
  end
end