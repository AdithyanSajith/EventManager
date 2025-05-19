class AddUniqueIndexToReviews < ActiveRecord::Migration[7.0]
  def change
    add_index :reviews, [:participant_id, :reviewable_id, :reviewable_type],
              unique: true,
              name: "index_reviews_on_participant_and_reviewable"
  end
end
