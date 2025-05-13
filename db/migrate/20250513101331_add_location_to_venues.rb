class AddLocationToVenues < ActiveRecord::Migration[7.2]
  def change
    add_column :venues, :location, :string
  end
end
