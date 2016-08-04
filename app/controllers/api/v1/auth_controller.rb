module Api
  module V1
    class AuthController < ApplicationController
      before_action :authenticate, only: :logout

      def login
        user = User.find_or_create_by(fb_id: auth_params[:fb_id]) do |user|
          user.username =  auth_params[:username]
          user.first_name =  auth_params[:first_name]
          user.last_name =  auth_params[:last_name]
          user.email =  auth_params[:email]
        end

        if user.errors.messages.empty?
          token = Authenticate.create_token(fb_id: user.fb_id, email: user.email)
          render json: { token: token }, status: 200
        else
          render json: { Error: user.errors.messages }, status: 422
        end
      end

      def logout
        user = User.find(@current_user.id)
        raw_token = request.headers["HTTP_AUTHORIZATION"]
        ExpiredToken.create(raw_token: raw_token)
        render json: { Status: "Logged out" }, status: 200
      end

      private

      def auth_params
        params.permit(:email, :username, :first_name, :last_name, :fb_id)
      end
    end
  end
end
