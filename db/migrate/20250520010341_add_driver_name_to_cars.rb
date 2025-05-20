class AddDriverNameToCars < ActiveRecord::Migration[8.0]
  def change
    add_column :cars, :driver_name, :string
  end
end
