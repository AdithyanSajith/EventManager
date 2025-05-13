class CreateManagedEvents < ActiveRecord::Migration[7.2]
  def change
    create_table :managed_events do |t|
      t.string :title
      t.text :description
      t.datetime :starts_at
      t.datetime :ends_at
      t.references :host, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.references :venue, null: false, foreign_key: true

      t.timestamps
    end
  end
end
