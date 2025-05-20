class Car < ApplicationRecord
  belongs_to :event
  belongs_to :driver, class_name: 'User'
  has_many :participants
  
  validates :seats, presence: true, numericality: { greater_than: 0 }
  validates :driver_id, presence: true
  
  def available_seats
    seats - participants.count
  end
end
