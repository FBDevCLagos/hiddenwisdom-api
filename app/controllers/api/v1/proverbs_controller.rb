module Api
  module V1
    class ProverbsController < ApplicationController
      before_action :set_proverb, only: [:show, :update, :destroy, :translations]
      before_action :check_tags, only: [:create]
      before_action :authenticate, except: [:index, :show]
      before_action :set_locale

      def index
        proverbs = Proverb.paginate(params)
        render json: proverbs, status: :ok
      end

      def show
        render json: @proverb, status: :ok
      end

      def create
        data = proverb_params.merge!(user_id: @current_user.id)
        @proverb = Proverb.new(data)
        if @proverb.save
          render json: @proverb, status: :created
        else
          render json: { error: "proverb could not be saved" }, status: :unprocessable_entity
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

      def set_locale
        I18n.locale = params[:locale] || I18n.default_locale
      end

      def set_proverb
        @proverb = Proverb.find(params[:id])
      end

      def proverb_params
        params.require(:proverb).permit(:body, :locale, all_tags: [])
      end

      def valid_translation?
        translations = params[:proverb][:translations]
        if translations
          return true if translations[0] == ""
          translations.all? do |translation|
            Proverb.new(translation.symbolize_keys.merge(
                          user_id: current_user.id
            )).valid?
          end
        else
          true
        end
      end

      def create_translations
        translations = params[:proverb][:translations]
        tags = @proverb.tags.map(&:name)
        if translations
          return true if translations[0] == ""
          translations.each do |translation|
            Proverb.create(translation.symbolize_keys.merge(
                             root_id: @proverb.id,
                             all_tags: tags,
                             user_id: current_user.id
            ))
          end
        else
          true
        end
      end


      def check_tags
        unless proverb_params["all_tags"] && proverb_params["all_tags"].is_a?(Array)
          render json: { tag_error: "tags must be in an array" }.to_json, status: 401
        end
      end
    end
  end
end
