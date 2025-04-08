# frozen_string_literal: true

module Spree
  module Admin
    class PricesController < ResourceController
      belongs_to 'spree/product', find_by: :slug
      before_action :check_pricelist_price, only: [:edit, :update, :destroy]

      def index
        params[:q] ||= {}

        @search = @product.prices.kept.accessible_by(current_ability, :index).ransack(params[:q])
        @master_prices = @search.result
          .currently_valid
          .for_master
          .order(:variant_id, :country_iso, :currency)
          .page(params[:page]).per(Spree::Config.admin_variants_per_page)
        @variant_prices = @search.result
          .currently_valid
          .for_variant
          .order(:variant_id, :country_iso, :currency)
          .page(params[:variants_page]).per(Spree::Config.admin_variants_per_page)
      end

      def edit
      end

      private

      def check_pricelist_price
        if @price.is_pricelist_price
          flash[:error] = t('spree.admin.prices.errors.price_belongs_to_pricelist')
          redirect_to admin_product_prices_path(@product)
        end
      end
    end
  end
end
