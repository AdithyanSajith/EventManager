class CreateTickets < ActiveRecord::Migration[7.2]
  def change
    create_table :tickets do |t|
      t.references :registration, null: false, foreign_key: true
      t.string :ticket_number
      t.datetime :issued_at

      t.timestamps
    end
  end
end
