class Event < ApplicationRecord
  has_many :participants
  
  validates :title, presence: true
  validates :description, presence: true
  validates :date, presence: true
  # validates :location, presence: true
end
