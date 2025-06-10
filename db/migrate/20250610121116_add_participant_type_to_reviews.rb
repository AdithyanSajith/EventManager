class AddParticipantTypeToReviews < ActiveRecord::Migration[7.2]
  def change
    add_column :reviews, :participant_type, :string
  end
end
