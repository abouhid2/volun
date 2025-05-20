class AddDetailsToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :total_participants, :integer
    add_column :events, :total_cars, :integer
  end
end
