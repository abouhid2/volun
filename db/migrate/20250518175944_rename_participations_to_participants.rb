class RenameParticipationsToParticipants < ActiveRecord::Migration[8.0]
  def change
    rename_table :participations, :participants
  end
end
