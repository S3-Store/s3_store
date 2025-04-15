# frozen_string_literal: true

json.price_lists(@price_lists) do |price_list|
  json.partial!("spree/api/price_lists/price_list", price_list:)
end
json.partial! 'spree/api/shared/pagination', pagination: @price_lists
