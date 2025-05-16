class ChangeHostIdForeignKeyInEvents < ActiveRecord::Migration[7.2]
  def change
    # Safely remove existing foreign key to hosts
    if foreign_key_exists?(:events, :hosts)
      remove_foreign_key :events, :hosts
    end

    # Add new foreign key to users table on host_id
    #add_foreign_key :events, :users, column: :host_id
  end
end
