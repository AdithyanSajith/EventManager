class RemoveRoleSpecificFieldsFromUsers < ActiveRecord::Migration[7.2]
  def change
    remove_column :users, :organisation, :string if column_exists?(:users, :organisation)
    remove_column :users, :website, :string if column_exists?(:users, :website)
    remove_column :users, :bio, :text if column_exists?(:users, :bio)
    remove_column :users, :number, :string if column_exists?(:users, :number)
    remove_column :users, :city, :string if column_exists?(:users, :city)
    remove_column :users, :birthdate, :date if column_exists?(:users, :birthdate)
    remove_column :users, :interest, :text if column_exists?(:users, :interest)
  end
end
