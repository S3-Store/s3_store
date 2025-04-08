# frozen_string_literal: true

module Spree
  module Admin
    class PriceListsController < ResourceController
      private

      def location_after_save
        edit_admin_price_list_path(@price_list)
      end
    end
  end
end
