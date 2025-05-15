class AddNameToParticipants < ActiveRecord::Migration[7.2]
  def change
    add_column :participants, :name, :string
  end
end
