class CreateDonations < ActiveRecord::Migration[8.0]
  def change
    create_table :donations do |t|
      t.references :event, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :donation_type
      t.decimal :quantity
      t.string :unit
      t.text :description

      t.timestamps
    end
  end
end
