class Request < ApplicationRecord
  belongs_to :entity
  
  validates :item_name, presence: true
  
  scope :pending, -> { where(fulfilled: false) }
  scope :fulfilled, -> { where(fulfilled: true) }
  scope :by_type, ->(type) { where(item_type: type) }
  
  def fulfill
    update(
      fulfilled: true,
      fulfilled_at: Time.current
    )
  end
  
  def self.item_types
    Inventory.item_types
  end
  
  def self.units
    Inventory.units
  end
end
