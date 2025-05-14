class AddCardNumberToPayments < ActiveRecord::Migration[7.2]
  def change
    add_column :payments, :card_number, :string
  end
end
