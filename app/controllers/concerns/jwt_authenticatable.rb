require 'jwt'

module JwtAuthenticatable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user
  end

  private

  def authenticate_user
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    
    begin
      decoded = JWT.decode(header, jwt_secret_key).first
      @current_user = User.find(decoded['user_id'])
    rescue JWT::DecodeError
      render json: { errors: ['Invalid token'] }, status: :unauthorized
    rescue ActiveRecord::RecordNotFound
      render json: { errors: ['User not found'] }, status: :unauthorized
    end
  end

  def current_user
    @current_user
  end

  def jwt_secret_key
    Rails.application.credentials.secret_key_base || 'development_secret_key'
  end
end 