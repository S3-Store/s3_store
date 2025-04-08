class AddContainTaxesAndIsPricelistPriceToPrices < ActiveRecord::Migration[7.0]
  def change
    add_column :spree_prices, :contain_taxes, :boolean, default: false
    add_column :spree_prices, :is_pricelist_price, :boolean, default: false
  end
end
