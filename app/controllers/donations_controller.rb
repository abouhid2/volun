class DonationsController < ApplicationController
  skip_before_action :authenticate_user
  before_action :set_event
  before_action :set_donation, only: [:update, :destroy, :duplicate]

  def index
    @donations = @event.donations.includes(:user)
    render json: @donations
  end

  def create
    @donation = @event.donations.build(donation_params)
    @donation.user = current_user

    if @donation.save
      render json: @donation, status: :created
    else
      render json: { errors: @donation.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @donation.update(donation_params)
      render json: @donation
    else
      render json: { errors: @donation.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @donation.destroy
    head :no_content
  end

  def duplicate
    new_donation = @donation.dup
    new_donation.user = current_user
    new_donation.event = @event

    if new_donation.save
      render json: new_donation, status: :created
    else
      render json: { errors: new_donation.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_donation
    @donation = @event.donations.find(params[:id])
  end

  def donation_params
    params.require(:donation).permit(:donation_type, :quantity, :unit, :description, :car_id)
  end
end
