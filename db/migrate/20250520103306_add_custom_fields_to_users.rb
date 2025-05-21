class AddCustomFieldsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :name, :string
    add_column :users, :role, :string
    add_column :users, :interest, :text
    add_column :users, :city, :string
    add_column :users, :birthdate, :date
    add_column :users, :organisation, :string
    add_column :users, :website, :string
    add_column :users, :number, :string
    add_column :users, :bio, :text
  end
end
