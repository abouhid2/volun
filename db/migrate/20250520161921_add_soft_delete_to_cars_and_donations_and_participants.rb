class AddSoftDeleteToCarsAndDonationsAndParticipants < ActiveRecord::Migration[8.0]
  def change
    add_column :cars, :deleted_at, :datetime
    add_column :donations, :deleted_at, :datetime
    add_column :participants, :deleted_at, :datetime

    add_index :cars, :deleted_at
    add_index :donations, :deleted_at
    add_index :participants, :deleted_at
  end
end
