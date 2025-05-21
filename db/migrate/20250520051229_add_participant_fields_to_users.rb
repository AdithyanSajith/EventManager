class AddParticipantFieldsToUsers < ActiveRecord::Migration[7.2]
  def change
    # Only add columns that are NOT already present
    add_column :users, :city, :string unless column_exists?(:users, :city)
    add_column :users, :birthdate, :date unless column_exists?(:users, :birthdate)
    add_column :users, :number, :integer unless column_exists?(:users, :number)
  end
end
