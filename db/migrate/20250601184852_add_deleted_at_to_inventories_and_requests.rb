class AddDeletedAtToInventoriesAndRequests < ActiveRecord::Migration[8.0]
  def change
    add_column :inventories, :deleted_at, :datetime
    add_index :inventories, :deleted_at
    
    add_column :requests, :deleted_at, :datetime
    add_index :requests, :deleted_at
  end
end
