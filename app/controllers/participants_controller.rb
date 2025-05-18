
    class ParticipantsController < ApplicationController
      skip_before_action :authenticate_user
      before_action :set_event
      before_action :set_participant, only: [:destroy]

      def create
        participant_data = params[:participant].present? ? participant_params : direct_params
        participant = @event.participants.new(participant_data)
        
        if participant.save
          render json: participant, status: :created
        else
          render json: { errors: participant.errors.full_messages }, status: :unprocessable_entity
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
        params.require(:participant).permit(:name, :status)
      end

      def direct_params
        params.permit(:name, :status)
      end
    end
