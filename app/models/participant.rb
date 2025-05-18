class Participant < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :event
  
  validates :event_id, presence: true
  validates :status, presence: true, inclusion: { in: ['going', 'not_going', 'maybe'] }
  validates :name, presence: true, if: -> { user_id.blank? }
end
