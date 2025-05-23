class AddUserableToUsers < ActiveRecord::Migration[7.2]
  def change
    add_reference :users, :userable, polymorphic: true, null: true
  end
end
