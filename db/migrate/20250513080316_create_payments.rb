class CreatePayments < ActiveRecord::Migration[7.2]
  def change
    create_table :payments do |t|
      t.decimal :amount
      t.string :status
      t.datetime :paid_at
      t.references :registration, null: false, foreign_key: true

      t.timestamps
    end
  end
end
