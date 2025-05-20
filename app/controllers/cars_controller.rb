class CarsController < ApplicationController
  before_action :set_event
  before_action :set_car, only: [:update, :destroy]

  def index
    @cars = @event.cars.includes(:driver)
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

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_car
    @car = @event.cars.find(params[:id])
  end

  def car_params
    if params[:driver].present?
      params[:car][:driver_id] = params[:driver][:id]
    end
    params.require(:car).permit(:driver_id, :seats)
  end
end
