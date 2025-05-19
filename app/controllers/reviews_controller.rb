class ReviewsController < ApplicationController
  before_action :set_review, only: %i[show edit update destroy]
  before_action :authorize_participant!

  # GET /reviews
  def index
    @reviews = Review.all
  end

  # GET /reviews/1
  def show
  end

  # GET /reviews/new
  def new
    reviewable_class = params[:reviewable_type].constantize
    reviewable = reviewable_class.find(params[:reviewable_id])

    @review = Review.new(
      reviewable: reviewable,
      participant_id: current_user.id
    )

    @event = reviewable if reviewable_class == Event
  end

  # POST /reviews
  def create
    @review = Review.new(review_params)
    @review.reviewable_type = "Event"
    @review.reviewable_id = params[:event_id] || params[:review][:reviewable_id]
    @review.participant = current_user

    if @review.save
      redirect_to event_path(@review.reviewable_id), notice: "Review submitted!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /reviews/1
  def update
    if @review.update(review_params)
      redirect_to @review, notice: "Review was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /reviews/1
  def destroy
    @review.destroy!
    redirect_to reviews_path, status: :see_other, notice: "Review was successfully destroyed."
  end

  private

  def set_review
    @review = Review.find(params[:id])
  end

  def review_params
    params.require(:review).permit(:rating, :comment, :participant_id, :reviewable_id, :reviewable_type)
  end

  def authorize_participant!
    unless current_user&.role == "participant"
      redirect_to root_path, alert: "Only participants can leave reviews."
    end
  end
end
