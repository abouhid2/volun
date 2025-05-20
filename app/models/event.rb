class Event < ApplicationRecord
  acts_as_paranoid
  
  belongs_to :entity
  belongs_to :user
  has_many :participants
  has_many :cars
  has_many :users, through: :participants
  has_many :donations
  
  validates :title, presence: true
  validates :total_participants, presence: true, numericality: { greater_than: 0 }
  validates :total_cars, presence: true, numericality: { greater_than: 0 }
  
  def available_seats
    cars.sum(:seats) - participants.where.not(car_id: nil).count
  end
  
  def total_donations_by_type(type)
    donations.total_by_type(id, type)
  end
  
  def food_donations
    donations.food_donations
  end
  
  def supplies_donations
    donations.supplies_donations
  end
end
