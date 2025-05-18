class Participation < ApplicationRecord
  belongs_to :event
  
  validates :user_id, presence: true
  validates :event_id, presence: true
  validates :status, presence: true, inclusion: { in: ['going', 'not_going', 'maybe'] }
end
