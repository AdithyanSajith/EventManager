class AddDetailsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :name, :string
    add_column :users, :city, :string
    add_column :users, :birthdate, :date
    add_column :users, :interest, :string
    add_column :users, :phone, :string
  end
end
