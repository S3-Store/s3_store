# frozen_string_literal: true

json.price_list_items(@price_list_items) do |price_list_item|
  json.partial!("spree/api/price_list_items/price_list_item", price_list_item:)
end
json.partial! 'spree/api/shared/pagination', pagination: @price_list_items
