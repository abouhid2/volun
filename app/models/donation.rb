class Donation < ApplicationRecord
  belongs_to :event
  belongs_to :user
  belongs_to :car, optional: true
  has_many :inventory_transactions, dependent: :nullify
  
  validates :donation_type, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :unit, presence: true
  
  scope :by_type, ->(type) { where(donation_type: type) }
  scope :food_donations, -> { where(donation_type: ['food', 'drinks']) }
  scope :supplies_donations, -> { where(donation_type: ['cleaning_supplies', 'medical_supplies']) }
  
  def self.total_by_type(event_id, type)
    where(event_id: event_id, donation_type: type).sum(:quantity)
  end
  
  def add_to_inventory
    begin
      entity = event.entity
      inventory = entity.inventories.find_or_initialize_by(
        item_type: donation_type,
        item_name: donation_type,
        unit: unit
      )
      
      # If it's a new record, set the quantity
      if inventory.new_record?
        inventory.quantity = quantity
      else
        # If it exists, increase the quantity
        inventory.quantity += quantity
      end
      
      if inventory.save
        # Create a transaction record
        transaction = inventory_transactions.create(
          inventory: inventory,
          event: event,
          user: user,
          transaction_type: 'addition',
          quantity: quantity,
          notes: "Added from donation ##{id}"
        )
        
        return transaction
      end
    rescue => e
      Rails.logger.error("Failed to add donation to inventory: #{e.message}")
    end
    
    nil
  end
end
