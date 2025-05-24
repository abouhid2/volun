class InventoryService
  def self.add_stock(entity, item_params, user)
    inventory = entity.inventories.find_or_create_by(
      item_type: item_params[:item_type],
      item_name: item_params[:item_name],
      unit: item_params[:unit]
    )
    
    transaction = inventory.inventory_transactions.create(
      user: user,
      transaction_type: 'addition',
      quantity: item_params[:quantity],
      notes: item_params[:notes]
    )
    
    inventory.increase_stock(item_params[:quantity].to_d) if transaction.persisted?
    transaction
  end
  
  def self.use_stock(entity, item_params, event, user)
    inventory = entity.inventories.find_by(
      item_type: item_params[:item_type],
      item_name: item_params[:item_name],
      unit: item_params[:unit]
    )
    
    return { success: false, error: 'Inventory item not found' } unless inventory
    return { success: false, error: 'Insufficient stock' } if inventory.quantity < item_params[:quantity].to_d
    
    transaction = inventory.inventory_transactions.create(
      event: event,
      user: user,
      transaction_type: 'deduction',
      quantity: item_params[:quantity],
      notes: item_params[:notes]
    )
    
    if transaction.persisted? && inventory.decrease_stock(item_params[:quantity].to_d)
      { success: true, transaction: transaction }
    else
      { success: false, error: transaction.errors.full_messages.join(', ') }
    end
  end
  
  def self.convert_donation_to_stock(donation)
    entity = donation.event.entity
    inventory = entity.inventories.find_or_create_by(
      item_type: donation.donation_type,
      item_name: donation.donation_type,
      unit: donation.unit
    )
    
    transaction = inventory.inventory_transactions.create(
      event: donation.event,
      donation: donation,
      user: donation.user,
      transaction_type: 'addition',
      quantity: donation.quantity,
      notes: "Added from donation ##{donation.id}"
    )
    
    inventory.increase_stock(donation.quantity) if transaction.persisted?
    transaction
  end
end 