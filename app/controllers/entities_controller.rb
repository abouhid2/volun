class EntitiesController < ApplicationController
  skip_before_action :authenticate_user
  before_action :set_entity, only: [:show, :update, :destroy]
  before_action :ensure_owner, only: [:destroy]

  def index
    @entities = Entity.all
    render json: @entities
  end

  def show
    render json: @entity
  end

  def create
    @entity = Entity.new(entity_params)
    @entity.user = current_user

    if @entity.save
      render json: @entity, status: :created
    else
      render json: { errors: @entity.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @entity.update(entity_params)
      render json: @entity
    else
      render json: { errors: @entity.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @entity.destroy
    head :no_content
  end

  private

  def set_entity
    @entity = Entity.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Entity not found' }, status: :not_found
  end

  def ensure_owner
    return unless @entity.user_id
    unless @entity.user_id == current_user&.id
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def entity_params
    params.require(:entity).permit(:name, :description, :logo_url, :website, :address, :phone, :email)
  end
end
