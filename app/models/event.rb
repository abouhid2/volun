class Event < ApplicationRecord
  acts_as_paranoid
  
  belongs_to :entity
  belongs_to :user
  has_many :participants
  
  validates :title, presence: true
  validates :description, presence: true
  validates :date, presence: true
  # validates :location, presence: true
end
