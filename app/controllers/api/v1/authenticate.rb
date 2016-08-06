require "jwt"
module Api
  module V1
    class Authenticate
      def self.secret
        ProverbsApi::Application.config.secret_token
      end

      def self.create_token(user_info, exp = Time.zone.now.to_i + 12 * 3600 )
        user_info[:exp] = exp
        JWT.encode user_info, secret, "HS512"
      end

      def self.decode_token(token)
        decoded = JWT.decode token, secret, true, algorithm: "HS512"
        [true, decoded.first]
      rescue JWT::ExpiredSignature
        [false, { Error: "This session has expired, please login again" }]
      rescue
        [false, { Error: "Invalid Token, please login again" }]
      end
    end
  end
end
