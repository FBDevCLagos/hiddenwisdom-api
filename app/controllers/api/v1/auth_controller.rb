module Api
  module V1
    class AuthController < ApplicationController
      before_action :authenticate, only: :logout

      def login
        uri = "https://graph.facebook.com/me"
        parameter = {
          fields: "id,name,email",
          access_token: params[:access_token]
        }

        http_client = Http.new(uri)
        response, status = http_client.get_request(parameter)
        authenticate_user(response, status)
      end

      def logout
        user = User.find(current_user.id)
        ExpiredToken.create(token: token)
        render json: { Status: "Logged out" }, status: 200
      end

      private
      def authenticate_user(response, status)
        if status == "200"
          user = User.find_or_create_user(response)
          token = Authenticate.create_token(fb_id: user.fb_id,email: user.email)
          render json: { token: token }, status: 200
        else
          render json: { error: response["error"]["message"] }
        end
      end
    end
  end
end
