class DonationsController < ApplicationController
  before_action :set_event
  before_action :set_donation, only: [:update, :destroy]

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

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_donation
    @donation = @event.donations.find(params[:id])
  end

  def donation_params
    params.require(:donation).permit(:donation_type, :quantity, :unit, :description)
  end
end
