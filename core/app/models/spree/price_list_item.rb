# frozen_string_literal: true

module Spree
  class PriceListItem < Spree::Base
    belongs_to :price_list, class_name: 'Spree::PriceList'
    belongs_to :price, class_name: 'Spree::Price', dependent: :destroy

    validates :price_list, presence: true
    validates :price, presence: true

    before_validation :set_default_currency_and_country
    validate :currency_and_country_check

    accepts_nested_attributes_for :price

    private

    # Sets the default currency and country for the price based on the associated price list
    # and marks the price as a price list price if it is not already set
    def set_default_currency_and_country
      if price
        price.currency ||= price_list.currency
        price.country_iso ||= price_list.country_iso
        price.is_pricelist_price = true
      end
    end

    # Validates that the currency and country of the price match the price list
    # if they are present
    # Adds an error if there is a mismatch
    def currency_and_country_check
      if price
        if price_list.currency != price.currency
          errors.add(:price, :does_not_match_price_list_currency)
        elsif price_list.country_iso != price.country_iso
          errors.add(:price, :does_not_match_price_list_country)
        end
      end
    end
  end
end
