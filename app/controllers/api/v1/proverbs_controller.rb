module Api
  module V1
    class ProverbsController < ApplicationController
      before_action :set_proverb, only: [:show, :update, :destroy]
      before_action :authenticate

      # GET /proverbs
      # GET /proverbs.json
      def index
        proverbs = Proverb.all

        render json: proverbs, status: :ok, root: false
      end

      # GET /proverbs/1
      # GET /proverbs/1.json
      def show
        render json: @proverb, status: :ok
      end

      # POST /proverbs
      # POST /proverbs.json
      def create
        data = proverb_params.merge!(user_id: @current_user.id)
        @proverb = Proverb.create(data)
        if @proverb
          render json: @proverb, status: :created
        else
          render json: @proverb.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /proverbs/1
      # PATCH/PUT /proverbs/1.json
      def update
        # @proverb = Proverb.find(params[:id])

        if @proverb.update(proverb_params)
          render json: @proverb, status: :ok
        else
          render json: @proverb.errors, status: :unprocessable_entity
        end
      end

      # DELETE /proverbs/1
      # DELETE /proverbs/1.json
      def destroy
        @proverb.destroy
        head :no_content
      end

      private

        def set_proverb
          @proverb = Proverb.find(params[:id])
        end

        def proverb_params
          params.require(:proverb).permit(:language, :body, :root)
        end
    end
  end
end
