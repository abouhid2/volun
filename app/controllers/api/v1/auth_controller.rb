require 'jwt'

module Api
  module V1
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
        user = User.find_by(email: params[:email])
        if user&.authenticate(params[:password])
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

      def generate_token(user_id)
        JWT.encode({ user_id: user_id, exp: 24.hours.from_now.to_i }, jwt_secret_key)
      end

      def jwt_secret_key
        Rails.application.credentials.secret_key_base || 'development_secret_key'
      end
    end
  end
end 