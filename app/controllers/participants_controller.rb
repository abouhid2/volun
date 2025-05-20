class ParticipantsController < ApplicationController
  skip_before_action :authenticate_user
  before_action :set_event
  before_action :set_participant, only: [:update, :destroy]

  def index
    @participants = @event.participants
    render json: @participants
  end

  def create
    participant_data = params[:participant].present? ? participant_params : direct_params
    participant = @event.participants.new(participant_data)
    
    if participant.save
      render json: participant, status: :created
    else
      render json: { errors: participant.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if params[:participant].present?
      if @participant.update(participant_params)
        render json: @participant
      else
        render json: { errors: @participant.errors.full_messages }, status: :unprocessable_entity
      end
    else
      if @participant.update(car_id: nil)
        render json: @participant
      else
        render json: { errors: @participant.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  def destroy
    @participant.destroy
    head :no_content
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Event not found' }, status: :not_found
  end

  def set_participant
    @participant = @event.participants.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Participant not found' }, status: :not_found
  end

  def participant_params
    params.require(:participant).permit(:name, :status, :car_id)
  end

  def direct_params
    params.permit(:name, :status, :car_id).merge(status: params[:status] || 'going')
  end
end
