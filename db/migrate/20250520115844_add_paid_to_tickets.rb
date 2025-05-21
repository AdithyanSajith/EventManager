class AddPaidToTickets < ActiveRecord::Migration[7.2]
  def change
    add_column :tickets, :paid, :boolean, default: false
  end
end
