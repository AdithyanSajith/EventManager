class ChangeParticipantForeignKeyInRegistrations < ActiveRecord::Migration[7.2]
  def change
    remove_foreign_key :registrations, :participants
    add_foreign_key :registrations, :users, column: :participant_id
  end
end
