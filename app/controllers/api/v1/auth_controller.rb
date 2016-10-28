module Api
  module V1
    class AuthController < ApplicationController
      before_action :authenticate, only: :logout

      def login
        account_kit = AccountKit.new(params[:access_token])
        message, status = account_kit.get_message_and_status
        render json: message, status: status
      end

      def logout
        ExpiredToken.create(token: token)
        render json: { Status: "Logged out" }, status: 200
      end
    end
  end
end
