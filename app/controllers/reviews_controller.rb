class ReviewsController < ApplicationController
  before_action :set_review, only: %i[show edit update destroy]
  before_action :authorize_participant!
  before_action :set_reviewable, only: %i[new create] # find target of review

  def index
    @reviews = Review.all.includes(:participant, :reviewable)
  end

  def show
    Rails.logger.debug "📦 ReviewsController#show called with id=#{params[:id]}"
  end

  def new
    @review = Review.new(reviewable: @reviewable, participant: current_resource_owner.userable)
  end

  def create
    @review = Review.new(review_params)
    @review.reviewable = @reviewable
    @review.participant = current_resource_owner.userable

    if @review.save
      redirect_to @reviewable, notice: "Review submitted!"
    else
      flash.now[:alert] = @review.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @review.update(review_params)
      redirect_to @review.reviewable, notice: "Review updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @review.destroy!
    redirect_to reviews_path, status: :see_other, notice: "Review was deleted."
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
    redirect_to root_path, alert: "Only participants can review." unless current_resource_owner&.role == "participant"
  end
end
