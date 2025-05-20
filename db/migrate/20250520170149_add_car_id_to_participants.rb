class AddCarIdToParticipants < ActiveRecord::Migration[7.0]
  def change
    add_column :participants, :car_id, :integer
    add_index :participants, :car_id
    add_foreign_key :participants, :cars
  end
end
