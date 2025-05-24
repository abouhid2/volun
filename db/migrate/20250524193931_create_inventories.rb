class CreateInventories < ActiveRecord::Migration[8.0]
  def change
    create_table :inventories do |t|
      t.references :entity, null: false, foreign_key: true
      t.string :item_name, null: false
      t.string :item_type, null: false
      t.decimal :quantity, precision: 10, scale: 2, default: 0, null: false
      t.string :unit, null: false
      t.text :notes

      t.timestamps
    end
    
    add_index :inventories, [:entity_id, :item_type, :item_name, :unit], unique: true, name: 'idx_inventory_unique_items'
  end
end
