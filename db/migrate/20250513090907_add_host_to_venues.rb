class AddHostToVenues < ActiveRecord::Migration[7.2]
  def change
    add_reference :venues, :host, null: false, foreign_key: true
  end
end
