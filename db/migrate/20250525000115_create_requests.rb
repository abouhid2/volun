class CreateRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :requests do |t|
      t.references :entity, null: false, foreign_key: true
      t.string :item_name, null: true
      t.string :item_type, null: true
      t.decimal :quantity, precision: 10, scale: 2, null: true, default: 1
      t.string :unit, null: true
      t.boolean :fulfilled, default: false
      t.datetime :fulfilled_at
      t.string :requested_by, null: true
      t.text :notes
      t.references :event, null: true, foreign_key: true
      t.references :inventory, null: true, foreign_key: true

      t.timestamps
    end
    
    add_index :requests, :fulfilled
    add_index :requests, :item_type
  end
end
