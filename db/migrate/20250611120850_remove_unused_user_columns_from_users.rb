class RemoveUnusedUserColumnsFromUsers < ActiveRecord::Migration[7.2]
  def change
    remove_column :users, :organisation, :string
    remove_column :users, :website, :string
    remove_column :users, :bio, :text
    remove_column :users, :interest, :string
    remove_column :users, :city, :string
    remove_column :users, :birthdate, :date
    remove_column :users, :number, :string
  end
end
