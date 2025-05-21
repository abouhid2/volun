class Donation < ApplicationRecord
  belongs_to :event
  belongs_to :user
  belongs_to :car, optional: true
  
  validates :donation_type, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :unit, presence: true
  
  scope :by_type, ->(type) { where(donation_type: type) }
  scope :food_donations, -> { where(donation_type: ['food', 'drinks']) }
  scope :supplies_donations, -> { where(donation_type: ['cleaning_supplies', 'medical_supplies']) }
  
  def self.total_by_type(event_id, type)
    where(event_id: event_id, donation_type: type).sum(:quantity)
  end
end
