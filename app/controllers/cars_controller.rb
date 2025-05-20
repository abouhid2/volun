class CarsController < ApplicationController
  before_action :set_event
  before_action :set_car, only: [:update, :destroy, :clean_seats]

  def index
    @cars = @event.cars
    render json: @cars
  end

  def create
    @car = @event.cars.build(car_params)

    if @car.save
      render json: @car, status: :created
    else
      render json: { errors: @car.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @car.update(car_params)
      render json: @car
    else
      render json: { errors: @car.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @car.destroy
    head :no_content
  end

  def clean_seats
    begin
      driver_ids = params[:driver_ids] || []
      @car.clean_seats(driver_ids)
      render json: { message: 'Car seats cleaned successfully', car: @car }
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Event not found' }, status: :not_found
  end

  def set_car
    @car = @event.cars.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Car not found' }, status: :not_found
  end

  def car_params
    if params[:driver].present?
      params[:car][:driver_name] = params[:driver][:name]
    end
    params.require(:car).permit(:driver_name, :seats)
  end
end
