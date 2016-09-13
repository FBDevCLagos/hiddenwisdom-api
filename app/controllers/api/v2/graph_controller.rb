module Api
  module V2
    class GraphController < ApplicationController
      def process_query
        @current_user = User.last
        query = params[:query]
        vars = params[:variables] || {}
        result = ProverbSchema.execute(query, variables: vars, context: {current_user: @current_user} )
        render json: result
      end
    end
  end
end
