class Inventory < ApplicationRecord
  belongs_to :entity
  has_many :inventory_transactions, dependent: :destroy
  
  validates :item_name, presence: true
  validates :item_type, presence: true
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :unit, presence: true
  
  scope :by_type, ->(type) { where(item_type: type) }
  scope :available, -> { where('quantity > 0') }
  
  def self.item_types
    DonationSetting.default_types
  end
  
  def self.units
    DonationSetting.default_units
  end
  
  def decrease_stock(amount)
    if amount > quantity
      errors.add(:quantity, "not enough stock available")
      return false
    end
    
    update(quantity: quantity - amount)
  end
  
  def increase_stock(amount)
    update(quantity: quantity + amount)
  end
end 