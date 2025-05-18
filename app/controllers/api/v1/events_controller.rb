module Api
  module V1
    class EventsController < ApplicationController
      def index
        events = Event.all
        render json: events
      end

      def show
        event = Event.find(params[:id])
        render json: event
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Event not found' }, status: :not_found
      end

      def create
        event = Event.new(event_params)
        if event.save
          render json: event, status: :created
        else
          render json: { errors: event.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        event = Event.find(params[:id])
        if event.update(event_params)
          render json: event
        else
          render json: { errors: event.errors.full_messages }, status: :unprocessable_entity
        end
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Event not found' }, status: :not_found
      end

      def destroy
        event = Event.find(params[:id])
        event.destroy
        head :no_content
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Event not found' }, status: :not_found
      end

      private

      def event_params
        params.require(:event).permit(:title, :description, :date, :location)
      end
    end
  end
end
