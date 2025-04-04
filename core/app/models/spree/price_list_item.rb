# frozen_string_literal: true

module Spree
  class PriceListItem < Spree::Base
    belongs_to :price_list, class_name: 'Spree::PriceList'
    belongs_to :price, class_name: 'Spree::Price'

    validates :price_list, presence: true
    validates :price, presence: true
  end
end
