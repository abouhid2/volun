class CreateCars < ActiveRecord::Migration[8.0]
  def change
    create_table :cars do |t|
      t.references :event, null: false, foreign_key: true
      t.references :driver, null: false, foreign_key: { to_table: :users }
      t.integer :seats

      t.timestamps
    end
  end
end
