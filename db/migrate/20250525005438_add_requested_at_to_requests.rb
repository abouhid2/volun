class AddRequestedAtToRequests < ActiveRecord::Migration[8.0]
  def up
    add_column :requests, :requested_at, :datetime
    
    # Set requested_at to created_at for existing records
    execute("UPDATE requests SET requested_at = created_at")
  end
  
  def down
    remove_column :requests, :requested_at
  end
end
