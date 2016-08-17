require "net/http"
module Api
  module V1
    class Http
      attr_reader :uri
      def initialize(uri)
        @uri = URI(uri)
      end

      def get_request(params = {})
        uri.query = URI.encode_www_form(params) if params.present?
        response = Net::HTTP.get_response(uri)
        [JSON.parse(response.body), response.code]
      end
    end
  end
end
