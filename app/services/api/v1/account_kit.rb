module Api
  module V1
    class AccountKit
      attr_reader :access_token

      def initialize(access_token)
        @access_token = access_token
      end

      def get_message_and_status
        begin
          user_account = Facebook::AccountKit::UserAccount.new(access_token)
          user = User.find_or_create_user(user_account.fetch_user_info)
          return [{ token: get_token(user), user: user }, 200]
        rescue
          return [{ error: "Invalid Access Token" }, "400"]
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
