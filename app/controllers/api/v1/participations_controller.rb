module Api
  module V1
    class ParticipationsController < ApplicationController
      before_action :set_event
      before_action :set_participation, only: [:update, :destroy]

      def create
        participation = @event.participations.new(participation_params)
        if participation.save
          render json: participation, status: :created
        else
          render json: { errors: participation.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @participation.update(participation_params)
          render json: @participation
        else
          render json: { errors: @participation.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @participation.destroy
        head :no_content
      end

      private

      def set_event
        @event = Event.find(params[:event_id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Event not found' }, status: :not_found
      end

      def set_participation
        @participation = @event.participations.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Participation not found' }, status: :not_found
      end

      def participation_params
        params.require(:participation).permit(:user_id, :status)
      end
    end
  end
end
