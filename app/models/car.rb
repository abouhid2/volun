class Car < ApplicationRecord
  belongs_to :event
  has_many :participants
  
  validates :seats, presence: true, numericality: { greater_than: 0 }
  validates :driver_name, presence: true
  
  def available_seats
    seats - participants.count
  end
end
