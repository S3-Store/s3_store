# frozen_string_literal: true

module Spree
  module Admin
    class PriceListsController < ResourceController
      before_action :load_data, except: :index

      private

      def load_data
        @prices = Spree::Price.includes(:variant).map do |price|
                ["#{price.variant.descriptive_name} - #{price.amount} #{price.currency} #{price.country&.iso_name}", price.id]
        end
      end
    end
  end
end
