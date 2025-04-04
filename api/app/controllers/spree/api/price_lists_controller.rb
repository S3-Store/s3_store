# frozen_string_literal: true

module Spree
  module Api
    class PriceListsController < Spree::Api::BaseController
      before_action :find_price_list, only: [:show, :update, :destroy]

      def index
        authorize! :read, Spree::PriceList

        @price_lists = Spree::PriceList.all
        render json: @price_lists.as_json(methods: :prices)
      end

      def show
        authorize! :read, @price_list

        render json: @price_list.as_json(methods: :prices)
      end

      def create
        authorize! :create, Spree::PriceList

        @price_list = Spree::PriceList.new(price_list_params)
        if @price_list.save
          render json: @price_list.as_json(methods: :prices), status: :created
        else
          render json: @price_list.errors, status: :unprocessable_entity
        end
      end

      def update
        authorize! :update, Spree::PriceList

        if @price_list.update(price_list_params)
          render json: @price_list.as_json(methods: :prices), status: :ok
        else
          render json: @price_list.errors, status: :unprocessable_entity
        end
      end

      def destroy
        authorize! :destroy, Spree::PriceList

        if @price_list.destroy
          render json: { message: "Successfully Destroyed", object: @price_list }, status: :ok
        else
          invalid_resource!(@price_list)
        end
      end

      private

      def find_price_list
        @price_list = Spree::PriceList.find(params[:id])
      end

      def price_list_params
        params.require(:price_list).permit(permitted_price_list_attributes)
      end
    end
  end
end
