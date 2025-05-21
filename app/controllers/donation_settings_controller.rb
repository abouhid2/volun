class DonationSettingsController < ApplicationController
  skip_before_action :authenticate_user
  before_action :set_event
  before_action :set_donation_setting

  def show
    if @donation_setting
      render json: @donation_setting
    else
      @donation_setting = @event.create_donation_setting(
        types: DonationSetting.default_types,
        units: DonationSetting.default_units
      )
      render json: @donation_setting
    end
  end

  def update
    if @donation_setting.update(donation_setting_params)
      render json: @donation_setting
    else
      render json: { errors: @donation_setting.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Event not found' }, status: :not_found
  end

  def set_donation_setting
    @donation_setting = @event.donation_setting
  end

  def donation_setting_params
    params.require(:donation_setting).permit(types: [], units: [])
  end
end 