module Api
  module V1
    class ProverbsController < ApplicationController
      before_action :set_proverb, only: [:show, :update, :destroy, :translations]
      before_action :authenticate

      # GET /proverbs
      # GET /proverbs.json
      def index
        proverbs = Proverb.all

        render json: proverbs, status: :ok
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
        if @proverb.id
          render json: @proverb, status: :created
        else
          render json: @proverb.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /proverbs/1
      # PATCH/PUT /proverbs/1.json
      def update
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

      def translations
        all_tranlations = @proverb.translations
        render json: all_tranlations, status: :ok, root: false
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
