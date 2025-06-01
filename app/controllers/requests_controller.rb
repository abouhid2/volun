class RequestsController < ApplicationController
  before_action :set_entity
  before_action :set_request, only: [:show, :update, :destroy, :fulfill]

  def index
    @requests = @entity.requests
    
    # Filter by status
    if params[:status] == 'pending'
      @requests = @requests.pending
    elsif params[:status] == 'fulfilled'
      @requests = @requests.fulfilled
    end
    
    # Filter by type
    @requests = @requests.by_type(params[:type]) if params[:type].present?
    
    # Sort
    @requests = @requests.order(created_at: :desc)
    
    render json: @requests
  end

  def show
    render json: @request
  end

  def create
    @request = @entity.requests.new(request_params)
    
    if @request.save
      render json: @request, status: :created
    else
      render json: { errors: @request.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @request.update(request_params)
      render json: @request
    else
      render json: { errors: @request.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @request.destroy
    head :no_content
  end

  def fulfill
    if !@request.fulfilled?
      @request.update(fulfilled: true, fulfilled_at: Time.current)
    else
      @request.update(fulfilled: false, fulfilled_at: nil)
    end
    render json: {
      request: @request,
      message: "Request status updated successfully"
    }
  end

  private

  def set_entity
    entity_id = params[:entity_id] || params[:event_id]
    @entity = Entity.find(entity_id)
  end

  def set_request
    @request = @entity.requests.find(params[:id])
  end

  def request_params
    params.require(:request).permit(:item_name, :item_type, :quantity, :unit, :requested_by, :notes, :fulfilled, :fulfilled_at, :requested_at)
  end
end
