class InventoryTransaction < ApplicationRecord
  belongs_to :inventory
  belongs_to :event, optional: true
  belongs_to :donation, optional: true
  belongs_to :user
  
  validates :transaction_type, presence: true, inclusion: { in: %w[addition deduction transfer] }
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  
  scope :additions, -> { where(transaction_type: 'addition') }
  scope :deductions, -> { where(transaction_type: 'deduction') }
  scope :transfers, -> { where(transaction_type: 'transfer') }
end 