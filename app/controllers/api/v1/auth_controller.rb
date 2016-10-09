module Api
  module V1
    class AuthController < ApplicationController
      before_action :authenticate, only: :logout

      def login
        message, status = account_kit_authentication || graph_authentication
        render json: message, status: status
      end

      def logout
        ExpiredToken.create(token: token)
        render json: { Status: "Logged out" }, status: 200
      end

      private

      def account_kit_authentication
        return false unless params[:kit_access_code]
        account_kit = AccountKit.new(params[:kit_access_code])
        account_kit.get_message_and_status
      end

      def graph_authentication
        return false unless params[:access_token]

        parameters = {
          fields: FIELDS,
          access_token: params[:access_token]
        }

        http_client = Http.new(FB_URL)
        response, response_status = http_client.get_request(parameters)
        message, status = authenticate_user(response, response_status)
      end

      def authenticate_user(response, status)
        return(
          [{ error: response["error"]["message"] }, 401]
        ) unless status == "200"
        user = User.find_or_create_user(response)
        token = Authenticate.create_token(fb_id: user.fb_id, email: user.email)
        [{ token: token, user: user }, 200]
      end
    end
  end
end
