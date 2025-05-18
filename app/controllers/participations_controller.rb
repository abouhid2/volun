
class ParticipantsController < ApplicationController
  skip_before_action :authenticate_user
  before_action :set_event
  before_action :set_participant, only: [:update, :destroy]

  def create
    participant = @event.participants.new(name: params[:name], status: params[:status] || 'going')
    if current_user
      participant.user = current_user
      participant.name = current_user.name
    end
    
    if participant.save
      render json: participant, status: :created
    else
      render json: { errors: participant.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @participant.update(participant_params)
      render json: @participant
    else
      render json: { errors: @participant.errors.full_messages }, status: :unprocessable_entity
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
end
