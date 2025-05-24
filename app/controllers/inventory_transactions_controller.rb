class InventoryTransactionsController < ApplicationController
  before_action :set_entity
  before_action :set_inventory
  
  def index
    @transactions = @inventory.inventory_transactions
                              .includes(:user, :event, :donation)
                              .order(created_at: :desc)
                              .page(params[:page] || 1)
                              .per(params[:per_page] || 20)
    
    render json: {
      transactions: @transactions.as_json(include: [:user, :event, :donation]),
      meta: {
        total_count: @transactions.total_count,
        total_pages: @transactions.total_pages,
        current_page: @transactions.current_page
      }
    }
  end
  
  def create
    @transaction = @inventory.inventory_transactions.new(transaction_params)
    @transaction.user = current_user
    
    begin
      ActiveRecord::Base.transaction do
        if @transaction.save
          if @transaction.transaction_type == 'addition'
            if !@inventory.update(quantity: @inventory.quantity + @transaction.quantity)
              raise ActiveRecord::Rollback
            end
          elsif @transaction.transaction_type == 'deduction'
            if @inventory.quantity >= @transaction.quantity
              if !@inventory.update(quantity: @inventory.quantity - @transaction.quantity)
                raise ActiveRecord::Rollback
              end
            else
              @transaction.errors.add(:quantity, "insufficient stock (available: #{@inventory.quantity} #{@inventory.unit})")
              raise ActiveRecord::Rollback
            end
          end
          
          render json: {
            transaction: @transaction.as_json(include: [:user, :event]),
            inventory: @inventory
          }, status: :created
        else
          render json: { errors: @transaction.errors.full_messages }, status: :unprocessable_entity
        end
      end
    rescue => e
      render json: { errors: [e.message] }, status: :unprocessable_entity
    end
  end
  
  private
  
  def set_entity
    @entity = Entity.find(params[:entity_id])
  end
  
  def set_inventory
    @inventory = @entity.inventories.find(params[:inventory_id])
  end
  
  def transaction_params
    params.require(:inventory_transaction).permit(:transaction_type, :quantity, :notes, :event_id)
  end
end 