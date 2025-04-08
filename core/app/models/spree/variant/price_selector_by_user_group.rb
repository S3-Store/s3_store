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
        user_group_id = price_options.desired_attributes[:user_group_id]

        # Filter prices based on user group if present
        prices = if user_group_id
          user_group = Spree::UserGroup.find_by(id: user_group_id)
          price_list = user_group&.price_list

          # Return price list prices if present, otherwise use variant prices
          price_list_prices = price_list ? variant.prices.joins(:price_list_items).where(spree_price_list_items: { price_list_id: price_list.id }) : []
          price_list_prices.any? ? price_list_prices : variant.prices
        else
          variant.prices
        end

        # Select and sort prices
        prices.select do |price|
          variant.discarded? || price.kept?
        end.sort_by do |price|
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
