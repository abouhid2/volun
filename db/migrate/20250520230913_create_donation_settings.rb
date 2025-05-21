class CreateDonationSettings < ActiveRecord::Migration[8.0]
  def change
    create_table :donation_settings do |t|
      t.references :event, null: false, foreign_key: true, index: { unique: true }
      t.jsonb :types, null: false, default: []
      t.jsonb :units, null: false, default: []

      t.timestamps
    end
  end
end
