class RemoveReferencesFromRequests < ActiveRecord::Migration[8.0]
  def change
    remove_reference :requests, :event, foreign_key: true
    remove_reference :requests, :inventory, foreign_key: true
  end
end
