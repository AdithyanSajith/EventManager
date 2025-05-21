class AddHostFieldsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :organisation, :string
    add_column :users, :website, :string
    add_column :users, :bio, :text
  end
end
