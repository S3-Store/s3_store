# frozen_string_literal: true

module Spree
  class Variant < Spree::Base
    # This class is responsible for selecting a price for a variant given certain pricing options.
    # A variant can have multiple or even dynamic prices. The `price_for_options`
    # method determines which price applies under the given circumstances.
    #
    class PriceSelectorByUserGroup
      # The pricing options represent "given circumstances" for a price: The currency
      # we need and the country that the price applies to.
      # Every price selector is designed to work with a particular set of pricing options
      # embodied in it's pricing options class.
      #
      def self.pricing_options_class
        Spree::Variant::PricingOptionsWithUserGroup
      end

      attr_reader :variant

      def initialize(variant)
        @variant = variant
      end

      # The variant's Spree::Price record, given a set of pricing options
      # @param [Spree::Variant::PricingOptions] price_options Pricing Options to abide by
      # @return [Spree::Price, nil] The most specific price for this set of pricing options.
      def price_for_options(price_options)
        sorted_prices_for(variant, price_options).detect do |price|
          (price.country_iso == price_options.desired_attributes[:country_iso] ||
           price.country_iso.nil?
          ) && price.currency == price_options.desired_attributes[:currency]
        end
      end

      private

      # Returns `#prices` prioritized for being considered as default price
      #
      # @return [Array<Spree::Price>]
      def sorted_prices_for(variant, price_options)
        prices = fetch_prices_for_user_group(variant, price_options)

        # Filter and sort prices
        filter_and_sort_prices(variant, prices)
      end

      # Fetch prices based on user group or default to variant prices
      #
      # @return [Array<Spree::Price>]
      def fetch_prices_for_user_group(variant, price_options)
        user_group_id = price_options.desired_attributes[:user_group_id]
        return variant.prices.without_pricelist unless user_group_id

        user_group = Spree::UserGroup.find_by(id: user_group_id)
        price_list = user_group&.price_list

        return variant.prices.without_pricelist unless price_list

        price_list_prices = variant.prices.joins(:price_list_item)
                                          .where(spree_price_list_items: { price_list_id: price_list.id })

        price_list_prices.any? ? price_list_prices : variant.prices.without_pricelist
      end

      # Filter and sort prices based on variant state and attributes
      #
      # @return [Array<Spree::Price>]
      def filter_and_sort_prices(variant, prices)
        prices.select { |price| variant.discarded? || price.kept? }
              .sort_by do |price|
                [
                  price.country_iso.nil? ? 0 : 1,
                  price.updated_at || Time.zone.now,
                  price.id || Float::INFINITY,
                ]
              end.reverse
      end
    end
  end
end
