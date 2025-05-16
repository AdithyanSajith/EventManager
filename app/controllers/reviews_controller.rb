class ReviewsController < ApplicationController
  before_action :set_review, only: %i[ show edit update destroy ]

  # GET /reviews or /reviews.json
  def index
    @reviews = Review.all
  end

  # GET /reviews/1 or /reviews/1.json
  def show
  end

  # GET /reviews/new
  # app/controllers/reviews_controller.rb
def new
  reviewable_class = params[:reviewable_type].constantize
  reviewable = reviewable_class.find(params[:reviewable_id])

  @review = Review.new(
    reviewable: reviewable,
    participant_id: current_participant.id
  )

  @event = reviewable if reviewable_class == Event
end



def create
  @review = Review.new(review_params)
  @review.reviewable_type = "Event"
  @review.reviewable_id = params[:event_id] || params[:review][:reviewable_id]
  @review.participant = current_participant

  if @review.save
    redirect_to event_path(@review.reviewable_id), notice: "Review submitted!"
  else
    render :new, status: :unprocessable_entity
  end
end



  # PATCH/PUT /reviews/1 or /reviews/1.json
  def update
    respond_to do |format|
      if @review.update(review_params)
        format.html { redirect_to @review, notice: "Review was successfully updated." }
        format.json { render :show, status: :ok, location: @review }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reviews/1 or /reviews/1.json
  def destroy
    @review.destroy!

    respond_to do |format|
      format.html { redirect_to reviews_path, status: :see_other, notice: "Review was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review
      @review = Review.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def review_params
  params.require(:review).permit(:rating, :comment, :participant_id, :reviewable_id, :reviewable_type)
end


end
