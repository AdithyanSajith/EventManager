class ReviewsController < ApplicationController
  layout "application"

  before_action :set_review, only: %i[show edit update destroy]
  before_action :authorize_participant!
  before_action :set_reviewable, only: %i[new create] # find target of review
  before_action :ensure_has_ticket_for_event, only: %i[new create]

  def index
    @reviews = Review.all
  end

  def show
    @review = Review.find(params[:id])
  end

  def new
    @review = Review.new(reviewable: @reviewable, participant: current_resource_owner.userable)
  end

  def create
    @review = Review.new(review_params)
    @review.reviewable = @reviewable
    @review.participant = current_resource_owner.userable

    if @review.save
      # Standard flash message
      render_flash_message(:success, "Review submitted!")

      # Store snackbar data in session
      reviewable_name = @reviewable.respond_to?(:title) ? @reviewable.title : @reviewable.name
      session[:review_snackbar] = {
        action: :submitted,
        details: "Thank you for reviewing #{reviewable_name}"
      }

      redirect_to @reviewable
    else
      # Standard flash message
      render_flash_message(:error, @review.errors.full_messages.to_sentence)

      # Immediate snackbar
      @snackbar_js = review_snackbar(:error, @review.errors.full_messages.to_sentence)

      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @review.update(review_params)
      # Standard flash message
      render_flash_message(:success, "Review updated.")

      # Store snackbar data in session
      reviewable_name = @review.reviewable.respond_to?(:title) ? @review.reviewable.title : @review.reviewable.name
      session[:review_snackbar] = {
        action: :updated,
        details: "Your review of #{reviewable_name} was updated"
      }

      redirect_to @review.reviewable
    else
      # Immediate snackbar
      @snackbar_js = review_snackbar(:error, @review.errors.full_messages.to_sentence)

      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    reviewable = @review.reviewable
    reviewable_name = reviewable.respond_to?(:title) ? reviewable.title : reviewable.name

    @review.destroy!

    # Standard flash message
    render_flash_message(:success, "Review was deleted.")

    # Store snackbar data in session
    session[:review_snackbar] = {
      action: :deleted,
      details: "Your review of #{reviewable_name} was deleted"
    }

    redirect_to reviews_path, status: :see_other
  end

  private

  def set_reviewable
    if params[:event_id]
      @reviewable = Event.find(params[:event_id])
    elsif params[:venue_id]
      @reviewable = Venue.find(params[:venue_id])
    else
      redirect_to root_path, alert: "Invalid review target."
    end
  end

  def set_review
    if params[:id] == 'new'
      Rails.logger.warn "⚠️ Intercepted attempt to access /reviews/new via show route."
      redirect_to root_path, alert: "Invalid review access." and return
    end

    @review = Review.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to reviews_path, alert: "Review not found."
  end

  def review_params
    params.require(:review).permit(:rating, :comment)
  end

  def authorize_participant!
    # Allow admin users automatic access
    if current_resource_owner.is_a?(AdminUser)
      return true
    end

    # For regular users, check for participant role
    unless current_resource_owner.is_a?(User) && current_resource_owner.role == "participant"
      render_flash_message(:error, "Only participants can review.")
      redirect_to root_path
    end
  end

  def ensure_has_ticket_for_event
    return if current_resource_owner.is_a?(AdminUser)
    return unless @reviewable.is_a?(Event)
    registration = current_resource_owner.userable.registrations.find_by(event_id: @reviewable.id)
    unless registration&.ticket.present?
      render_flash_message(:error, "You must have a ticket for this event to write a review.")
      redirect_to event_path(@reviewable)
    end
  end
end
