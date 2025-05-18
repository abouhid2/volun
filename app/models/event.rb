class Event < ApplicationRecord
  has_many :participations
  
  validates :title, presence: true
  validates :date, presence: true
  validates :location, presence: true
end
