class InventoriesController < ApplicationController
  skip_before_action :authenticate_user

  before_action :set_entity
  before_action :set_inventory, only: [:show, :update, :destroy]

  def index
    @inventories = @entity.inventories.all
    render json: @inventories
  end

  def show
    transactions = @inventory.inventory_transactions.includes(:user, :event, :donation).order(created_at: :desc).limit(20)
    render json: {
      inventory: @inventory,
      transactions: transactions.as_json(include: [:user, :event, :donation])
    }
  end

  def create
    @inventory = @entity.inventories.find_or_initialize_by(
      item_type: inventory_params[:item_type],
      item_name: inventory_params[:item_name],
      unit: inventory_params[:unit]
    )
    
    if @inventory.new_record?
      @inventory.quantity = inventory_params[:quantity].to_d
      @inventory.notes = inventory_params[:notes]
    else
      @inventory.quantity += inventory_params[:quantity].to_d
      @inventory.notes = inventory_params[:notes] if inventory_params[:notes].present?
    end
    
    if @inventory.save
      if params[:create_transaction] != 'false' && inventory_params[:quantity].to_d > 0
        begin
          transaction = @inventory.inventory_transactions.create(
            user: current_user,
            transaction_type: 'addition',
            quantity: inventory_params[:quantity],
            notes: inventory_params[:notes]
          )
        rescue => e
          Rails.logger.error("Failed to create inventory transaction: #{e.message}")
        end
      end
      
      render json: @inventory, status: :created
    else
      render json: { errors: @inventory.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @inventory.update(inventory_params)
      render json: @inventory
    else
      render json: { errors: @inventory.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @inventory.destroy
    head :no_content
  end
  
  def use_stock
    @inventory = @entity.inventories.find(params[:inventory_id])
    @event = Event.find(params[:event_id]) if params[:event_id].present?
    
    quantity = params[:quantity].to_d
    if @inventory.quantity < quantity
      render json: { errors: ["Insufficient stock. Available: #{@inventory.quantity} #{@inventory.unit}"] }, status: :unprocessable_entity
      return
    end
    
    transaction = @inventory.inventory_transactions.new(
      event: @event,
      user: current_user,
      transaction_type: 'deduction',
      quantity: quantity,
      notes: params[:notes]
    )
    
    if transaction.save && @inventory.update(quantity: @inventory.quantity - quantity)
      render json: { 
        inventory: @inventory, 
        transaction: transaction 
      }
    else
      render json: { errors: transaction.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_entity
    @entity = Entity.find(params[:entity_id])
  end
  
  def set_inventory
    @inventory = @entity.inventories.find(params[:id])
  end

  def inventory_params
    params.require(:inventory).permit(:item_name, :item_type, :quantity, :unit, :notes)
  end
end 