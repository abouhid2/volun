class PicturesController < ApplicationController
  skip_before_action :authenticate_user
  before_action :set_imageable
  before_action :set_picture, only: [:show, :update, :destroy]
  
  def index
    @pictures = @imageable.pictures
    render json: @pictures
  end
  
  def show
    render json: @picture
  end
  
  def create
    @picture = @imageable.pictures.new(picture_params)
    
    if @picture.save
      render json: @picture, status: :created
    else
      render json: { errors: @picture.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def update
    if @picture.update(picture_params)
      render json: @picture
    else
      render json: { errors: @picture.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def destroy
    @picture.destroy
    head :no_content
  end
  
  private
  
  def set_picture
    @picture = @imageable.pictures.find(params[:id])
  end
  
  def set_imageable
    resource, id = request.path.split('/')[1, 2]
    @imageable = resource.singularize.classify.constantize.find(id)
  rescue NameError, ActiveRecord::RecordNotFound
    render json: { error: 'Invalid resource type or ID' }, status: :bad_request
  end
  
  def picture_params
    params.require(:picture).permit(:image_url, :image)
  end
end
