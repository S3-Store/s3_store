# frozen_string_literal: true

module Spree
  module Admin
    class UserGroupsController < ResourceController
      before_action :load_data, except: :index

      private

      def load_data
        @price_list = Spree::PriceList.order(:name)
      end
    end
  end
end
