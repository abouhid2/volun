class RemoveDriverIdFromCars < ActiveRecord::Migration[8.0]
  def change
    remove_column :cars, :driver_id, :bigint
  end
end
