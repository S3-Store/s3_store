# frozen_string_literal: true

module Spree
  class PriceListItem < Spree::Base
    belongs_to :price_list, class_name: 'Spree::PriceList'
    belongs_to :price, class_name: 'Spree::Price', dependent: :destroy

    validates :price_list, presence: true
    validates :price, presence: true

    accepts_nested_attributes_for :price
  end
end
