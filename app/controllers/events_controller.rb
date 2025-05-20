class EventsController < ApplicationController
  skip_before_action :authenticate_user, only: [:index, :show]
  before_action :set_event, only: [:show, :update, :destroy, :duplicate]
  before_action :ensure_owner, only: [:destroy, :duplicate]

  def index
    events = Event.where(entity_id: params[:entity_id])
    render json: events
  end

  def show
    render json: @event
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
    new_event = @event.dup
    new_event.title = "#{@event.title} (Copy)"
    new_event.user = current_user
    new_event.entity = @event.entity

    if new_event.save
      @event.cars.each do |car|
        new_car = car.dup
        new_car.event = new_event
        new_car.save
      end

      @event.donations.each do |donation|
        new_donation = donation.dup
        new_donation.event = new_event
        new_donation.user = current_user
        new_donation.save
      end

      @event.participants.each do |participant|
        new_participant = participant.dup
        new_participant.event = new_event
        new_participant.save
      end

      render json: new_event, status: :created
    else
      render json: { errors: new_event.errors.full_messages }, status: :unprocessable_entity
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
