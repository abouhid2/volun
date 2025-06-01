class Request < ApplicationRecord
  acts_as_paranoid
  
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

  def unfulfill
    update(
      fulfilled: false,
      fulfilled_at: nil
    )
  end

  def fulfilled?
    fulfilled
  end
  
  def self.item_types
    Inventory.item_types
  end
  
  def self.units
    Inventory.units
  end
end
