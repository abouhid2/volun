class EntitiesController < ApplicationController
  before_action :set_entity, only: [:show, :update, :destroy]

  def index
    @entities = Entity.all
    render json: @entities
  end

  def show
    render json: @entity
  end

  def create
    @entity = Entity.new(entity_params)

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

  def entity_params
    params.require(:entity).permit(:name, :description, :logo_url, :website, :address, :phone, :email)
  end
end
