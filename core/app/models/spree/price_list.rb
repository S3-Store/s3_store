# frozen_string_literal: true

module Spree
  class PriceList < Spree::Base
    has_many :price_list_items, class_name: 'Spree::PriceListItem', dependent: :destroy
    has_many :prices, through: :price_list_items, class_name: 'Spree::Price'
    belongs_to :country, class_name: "Spree::Country", foreign_key: "country_iso", primary_key: "iso", optional: true

    validates :currency, inclusion: { in: ::Money::Currency.all.map(&:iso_code), message: :invalid_code }
    validates :country, presence: true, unless: -> { for_any_country? }

    validates :name, presence: true

    def for_any_country?
      country_iso.nil?
    end

    def country_iso=(country_iso)
      self[:country_iso] = country_iso.presence
    end
  end
end
