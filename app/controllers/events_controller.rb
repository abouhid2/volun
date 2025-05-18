class EventsController < ApplicationController
  skip_before_action :authenticate_user
  before_action :set_event, only: [:show, :update, :destroy]
  before_action :ensure_owner, only: [:destroy]

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
    params.require(:event).permit(:title, :description, :date, :location)
  end
end
