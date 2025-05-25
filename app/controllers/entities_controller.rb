class EntitiesController < ApplicationController
  skip_before_action :authenticate_user, only: [:index, :show]
  before_action :set_entity, only: [:show, :update, :destroy, :duplicate]
  before_action :ensure_owner, only: [:destroy, :duplicate]

  def index
    @entities = Entity.all
    render json: @entities
  end

  def show
    render json: @entity.as_json(include: {
      inventories: { 
        only: [:id, :item_name, :item_type, :quantity, :unit, :notes],
        methods: [:created_at, :updated_at]
      },
      requests: {
        only: [:id, :item_name, :item_type, :quantity, :unit, :fulfilled, :fulfilled_at, :requested_by, :notes],
        methods: [:created_at, :updated_at]
      }
    })
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

  def duplicate
    new_entity = @entity.dup
    new_entity.name = "#{@entity.name} (Copy)"
    new_entity.user = current_user

    if new_entity.save
      @entity.events.each do |event|
        new_event = event.dup
        new_event.entity = new_entity
        new_event.title = "#{event.title} (Copy)"
        new_event.save
      end
      render json: new_entity, status: :created
    else
      render json: { errors: new_entity.errors.full_messages }, status: :unprocessable_entity
    end
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
