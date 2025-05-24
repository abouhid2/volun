class CreateInventoryTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :inventory_transactions do |t|
      t.references :inventory, null: false, foreign_key: true
      t.references :event, null: true, foreign_key: true
      t.references :donation, null: true, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :transaction_type, null: false
      t.decimal :quantity, precision: 10, scale: 2, null: false
      t.text :notes

      t.timestamps
    end
    
    add_index :inventory_transactions, :transaction_type
  end
end
