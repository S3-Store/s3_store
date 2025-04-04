# frozen_string_literal: true

module Spree
  class PriceList < Spree::Base
    has_many :price_list_items, class_name: 'Spree::PriceListItem', dependent: :destroy
    has_many :prices, through: :price_list_items, class_name: 'Spree::Price'

    validates :name, presence: true
  end
end
