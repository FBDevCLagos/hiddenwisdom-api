module Api
  module V1
    class AccountKit
      attr_reader :access_code

      def initialize(access_code)
        @access_code = access_code
      end

      def get_message_and_status
        token_exchanger = Facebook::AccountKit::TokenExchanger.new(access_code)

        begin
          access_token = token_exchanger.fetch_access_token
          user_account = Facebook::AccountKit::UserAccount.new(access_token)
          user = User.find_or_create_user(user_account.fetch_user_info)
          return [{ token: get_token(user), user: user }, 200]
        rescue Facebook::AccountKit::InvalidRequest
          return [{ error: "Invalid Access Code" }, "400"]
        end
      end

      private

      def get_token(user_info)
        user_params = {}
        user_params[:email] = user_info.email if user_info.email
        user_params[:phone_number] = user_info.phone_number if user_info.phone_number
        Authenticate.create_token(user_params.merge(kit_id: user_info.kit_id))
      end
    end
  end
end
