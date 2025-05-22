require 'jwt'

class AuthController < ApplicationController
  skip_before_action :authenticate_user, only: [:login, :register]

  def register
    user = User.new(user_params)
    if user.save
      token = generate_token(user.id)
      render json: { token: token, user: user.as_json(except: :password_digest) }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: auth_params[:email])
    if user&.authenticate(auth_params[:password])
      token = generate_token(user.id)
      render json: { token: token, user: user.as_json(except: :password_digest) }
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :name)
  end

  def auth_params
    params.require(:auth).permit(:email, :password)
  end

  def generate_token(user_id)
    JWT.encode({ user_id: user_id, exp: 24.hours.from_now.to_i }, jwt_secret_key)
  end

  def jwt_secret_key
    Rails.application.credentials.secret_key_base || 'development_secret_key'
  end
end