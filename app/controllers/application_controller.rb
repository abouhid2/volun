class ApplicationController < ActionController::API
  include JwtAuthenticatable
  
  before_action :authenticate_user

  def current_user
    return @current_user if defined?(@current_user)
    header = request.headers['Authorization']
    return nil unless header
    
    begin
      decoded = JWT.decode(header.split(' ').last, jwt_secret_key).first
      @current_user = User.find(decoded['user_id'])
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      nil
    end
  end
end
