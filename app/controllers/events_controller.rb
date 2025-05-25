class EventsController < ApplicationController
  skip_before_action :authenticate_user, only: [:index, :show]
  before_action :set_event, only: [:show, :update, :destroy, :duplicate, :use_inventory]
  before_action :ensure_owner, only: [:destroy, :duplicate]

  def index
    events = Event.where(entity_id: params[:entity_id])
    events_with_counts = events.map do |event|
      event.as_json.merge(
        total_participants: event.total_participants,
        total_cars: event.total_cars,
        total_donations: event.total_donations
      )
    end
    render json: events_with_counts
  end

  def show
    includes = []
    includes << :donations if params[:include]&.include?('donations')
    includes << :participants if params[:include]&.include?('participants')
    includes << :cars if params[:include]&.include?('cars')
    includes << :comments if params[:include]&.include?('comments')
    
    response_data = @event.as_json
    response_data[:total_participants] = @event.total_participants
    response_data[:total_cars] = @event.total_cars
    response_data[:total_donations] = @event.total_donations
    
    if includes.any?
      included_data = @event.as_json(include: includes)
      includes.each do |include_name|
        response_data[include_name.to_s] = included_data[include_name.to_s]
      end
    end
    
    render json: response_data
  end

  def create
    event = current_user.events.new(event_params)
    event.entity_id = params[:entity_id]
    
    event.description = nil if event.description.blank?
    
    if event.save
      render json: event, status: :created
    else
      render json: { errors: event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @event.update(event_params)
      render json: @event
    else
      render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    head :no_content
  end

  def duplicate
    keep_cars = ActiveModel::Type::Boolean.new.cast(params[:keepCars])
    keep_donations = ActiveModel::Type::Boolean.new.cast(params[:keepDonations])
    keep_participants = ActiveModel::Type::Boolean.new.cast(params[:keepParticipants])

    new_event = @event.dup
    new_event.title = params[:title] || "#{@event.title} (Copy)"
    new_event.description = params[:description]
    new_event.date = params[:date] if params[:date].present?
    new_event.time = params[:time] if params[:time].present?
    new_event.location = params[:location] if params[:location].present?
    new_event.user = current_user
    new_event.entity = @event.entity

    if new_event.save
      if keep_cars
        @event.cars.each do |car|
          new_car = car.dup
          new_car.event = new_event
          new_car.save
        end
      end

      if keep_donations
        @event.donations.each do |donation|
          new_donation = donation.dup
          new_donation.event = new_event
          new_donation.user = current_user
          new_donation.car_id = nil
          new_donation.save
        end
      end

      if keep_participants
        @event.participants.each do |participant|
          new_participant = participant.dup
          new_participant.event = new_event
          new_participant.car_id = nil
          new_participant.save
        end
      end

      render json: new_event, status: :created
    else
      render json: { errors: new_event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def use_inventory
    inventory = @event.entity.inventories.find(params[:inventory_id])
    quantity = params[:quantity].to_d
    
    # Check if we have enough stock
    if inventory.quantity < quantity
      render json: { errors: ["Insufficient stock. Available: #{inventory.quantity} #{inventory.unit}"] }, status: :unprocessable_entity
      return
    end
    
    # Create transaction
    transaction = inventory.inventory_transactions.new(
      event: @event,
      user: current_user,
      transaction_type: 'deduction',
      quantity: quantity,
      notes: params[:notes] || "Used in event: #{@event.title}"
    )
    
    if transaction.save && inventory.update(quantity: inventory.quantity - quantity)
      render json: { 
        inventory: inventory, 
        transaction: transaction,
        message: "Successfully used #{quantity} #{inventory.unit} of #{inventory.item_name}" 
      }
    else
      render json: { errors: transaction.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_event
    @event = Event.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Event not found' }, status: :not_found
  end

  def ensure_owner
    return unless @event.user_id
    unless @event.user_id == current_user&.id
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def event_params
    params.require(:event).permit(:title, :description, :date, :time, :location)
  end
end
