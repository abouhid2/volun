class Donation < ApplicationRecord
  belongs_to :event
  belongs_to :user
  
  DONATION_TYPES = [
    'drinks',
    'food',
    'dog_food',
    'cleaning_supplies',
    'medical_supplies',
    'clothing',
    'other'
  ].freeze
  
  UNITS = [
    'kg',
    'g',
    'l',
    'ml',
    'units',
    'boxes',
    'bags'
  ].freeze
  
  validates :donation_type, presence: true, inclusion: { in: DONATION_TYPES }
  
  scope :by_type, ->(type) { where(donation_type: type) }
  scope :food_donations, -> { where(donation_type: ['food', 'drinks']) }
  scope :supplies_donations, -> { where(donation_type: ['cleaning_supplies', 'medical_supplies']) }
  
  def self.total_by_type(event_id, type)
    where(event_id: event_id, donation_type: type).sum(:quantity)
  end
end
