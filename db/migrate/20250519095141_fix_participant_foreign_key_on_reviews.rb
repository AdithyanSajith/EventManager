class FixParticipantForeignKeyOnReviews < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :reviews, column: :participant_id rescue nil
    add_foreign_key :reviews, :users, column: :participant_id
  end
end
