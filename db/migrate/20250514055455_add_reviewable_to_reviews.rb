class AddReviewableToReviews < ActiveRecord::Migration[7.2]
  def change
    add_reference :reviews, :reviewable, polymorphic: true, null: false
  end
end
