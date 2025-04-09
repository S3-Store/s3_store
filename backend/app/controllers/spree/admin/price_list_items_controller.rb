module Spree
  module Admin
    class PriceListItemsController < ResourceController
      belongs_to 'spree/price_list', find_by: :id
      before_action :set_price_list

      def new
        @price_list_item = @price_list.price_list_items.build
        @price_list_item.build_price
      end

      private

      def set_price_list
        @price_list = Spree::PriceList.find(params[:price_list_id])
      end

      def location_after_save
        edit_admin_price_list_path(@price_list)
      end

      def price_list_item_params
        params.require(:price_list_item).permit(:price_list_id, price_attributes: [:amount, :currency, :variant_id])
      end
    end
  end
end
