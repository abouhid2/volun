class Event < ApplicationRecord
  belongs_to :entity
  has_many :participants
  
  validates :title, presence: true
  validates :description, presence: true
  validates :date, presence: true
  # validates :location, presence: true
end
