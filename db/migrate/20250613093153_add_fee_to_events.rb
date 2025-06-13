class AddFeeToEvents < ActiveRecord::Migration[7.2]
  def change
    add_column :events, :fee, :decimal
  end
end
