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
      # Add to inventory if requested
      if params[:add_to_inventory]
        begin
          inventory_transaction = @donation.add_to_inventory
          if inventory_transaction&.persisted?
            render json: {
              donation: @donation,
              inventory_transaction: inventory_transaction,
              message: "Donation added and inventory updated"
            }, status: :created
          else
            render json: { 
              donation: @donation, 
              warning: "Donation created but failed to add to inventory"
            }, status: :created
          end
        rescue => e
          render json: { 
            donation: @donation, 
            warning: "Donation created but failed to add to inventory: #{e.message}"
          }, status: :created
        end
      else
        render json: @donation, status: :created
      end
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
  
  def add_to_inventory
    begin
      transaction = @donation.add_to_inventory
      
      if transaction&.persisted?
        render json: {
          donation: @donation,
          inventory_transaction: transaction,
          message: "Successfully added donation to inventory"
        }
      else
        render json: { errors: ["Failed to add donation to inventory"] }, status: :unprocessable_entity
      end
    rescue => e
      render json: { errors: ["Error: #{e.message}"] }, status: :unprocessable_entity
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
