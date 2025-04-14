# frozen_string_literal: true

module Spree
  module Api
    class PriceListsController < Spree::Api::BaseController
      before_action :find_price_list, only: [:show, :update, :destroy]

      def index
        authorize! :read, Spree::PriceList

        @price_lists = Spree::PriceList.ransack(params[:q]).result
        @price_lists = paginate(@price_lists)

        respond_with(@price_lists)
      end

      def show
        authorize! :read, @price_list

        respond_with(@price_list)
      end

      def create
        authorize! :create, Spree::PriceList

        @price_list = Spree::PriceList.new(price_list_params)

        if @price_list.save
          respond_with(@price_list, status: 201, default_template: :show)
        else
          invalid_resource!(@price_list)
        end
      end

      def update
        authorize! :update, Spree::PriceList

        if @price_list.update(price_list_params)
          respond_with(@price_list, default_template: :show)
        else
          invalid_resource!(@price_list)
        end
      end

      def destroy
        authorize! :destroy, Spree::PriceList

        if @price_list.destroy
          respond_with(@price_list, status: 204)
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
