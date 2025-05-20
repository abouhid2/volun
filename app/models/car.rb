class Car < ApplicationRecord
  belongs_to :event
  has_many :participants, dependent: :nullify
  
  validates :seats, presence: true, numericality: { greater_than: 0 }
  validates :driver_name, presence: true
  
  def available_seats
    seats - participants.count
  end

  def clean_seats(driver_ids = [])
    participants.where.not(id: driver_ids).update_all(car_id: nil)
  end
end
