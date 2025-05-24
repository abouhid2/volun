class CreatePictures < ActiveRecord::Migration[8.0]
  def change
    create_table :pictures do |t|
      t.string :imageable_type, null: false
      t.bigint :imageable_id, null: false
      t.string :image_url, null: false
      t.datetime :deleted_at

      t.timestamps
    end
    
    add_index :pictures, [:imageable_type, :imageable_id]
    add_index :pictures, :deleted_at
  end
end
