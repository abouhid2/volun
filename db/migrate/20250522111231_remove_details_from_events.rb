class RemoveDetailsFromEvents < ActiveRecord::Migration[8.0]
  def change
    remove_column :events, :total_participants, :integer
    remove_column :events, :total_cars, :integer
  end
end
