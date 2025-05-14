class RemoveEventIdFromReviews < ActiveRecord::Migration[7.2]
  def change
    remove_column :reviews, :event_id, :integer
  end
end
