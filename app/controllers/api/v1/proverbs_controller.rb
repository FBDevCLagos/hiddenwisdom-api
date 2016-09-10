module Api
  module V1
    class ProverbsController < ApplicationController
      before_action :set_proverb, only: [:show, :update, :destroy, :translations]
      before_action :authenticate, except: [:index, :show]

      def index
        proverbs = Proverb.all

        render json: proverbs, status: :ok
      end

      def show
        render json: @proverb, status: :ok
      end

      def create
        data = proverb_params.merge!(user_id: @current_user.id)
        @proverb = Proverb.create(data)
        if @proverb.id
          render json: @proverb, status: :created
        else
          render json: @proverb.errors, status: :unprocessable_entity
        end
      end

      def update
        if @proverb.update(proverb_params)
          render json: @proverb, status: :ok
        else
          render json: @proverb.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @proverb.destroy
        head :no_content
      end

      private

      def set_proverb
        @proverb = Proverb.find(params[:id])
      end

      def proverb_params
        params.require(:proverb).permit(:language, :body, :root_id, tags:[:id, :_destroy, :name])
      end
    end
  end
end
