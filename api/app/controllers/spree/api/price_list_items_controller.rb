# frozen_string_literal: true

module Spree
  module Api
    class PriceListItemsController < Spree::Api::BaseController
      before_action :set_price_list
      before_action :set_price_list_item, only: [:update, :destroy]

      def index
        authorize! :read, Spree::PriceListItem

        @price_list_items = @price_list.price_list_items.ransack(params[:q]).result
        @price_list_items = paginate(@price_list_items)

        respond_with(@price_list_items)
      end

      def create
        authorize! :create, Spree::PriceListItem

        @price_list_item = @price_list.price_list_items.build(price_list_item_params)

        if @price_list_item.save
          respond_with(@price_list_item, status: 201, default_template: :show)
        else
          invalid_resource!(@price_list_item)
        end
      end

      def update
        authorize! :update, Spree::PriceListItem

        if @price_list_item.update(price_list_item_params)
          respond_with(@price_list_item, default_template: :show)
        else
          invalid_resource!(@price_list_item)
        end
      end

      def destroy
        authorize! :destroy, Spree::PriceListItem

        if @price_list_item.destroy
          respond_with(@price_list_item, status: 204)
        else
          invalid_resource!(@price_list_item)
        end
      end

      private

      def set_price_list
        @price_list = Spree::PriceList.find(params[:price_list_id])
      end

      def set_price_list_item
        @price_list_item = @price_list.price_list_items.find(params[:id])
      end

      def price_list_item_params
        params.require(:price_list_item).permit(permitted_price_list_item_attributes)
      end
    end
  end
end
