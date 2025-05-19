class AddDetailsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :city, :string
    add_column :users, :birthdate, :date
    add_column :users, :interest, :integer
    add_column :users, :phone, :string
  end
end
