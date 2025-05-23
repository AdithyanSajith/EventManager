class CreateHostsAndParticipants < ActiveRecord::Migration[7.2]
  def change
    create_table :hosts do |t|
      t.string :organisation
      t.string :website
      t.text :bio
      t.string :number

      t.timestamps
    end

    create_table :participants do |t|
      t.text :interest
      t.string :city
      t.date :birthdate

      t.timestamps
    end
  end
end
