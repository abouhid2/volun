class AddDeletedAtToEntities < ActiveRecord::Migration[8.0]
  def change
    add_column :entities, :deleted_at, :datetime
    add_index :entities, :deleted_at
  end
end
