class AddContainTaxesToPrices < ActiveRecord::Migration[7.0]
  def change
    add_column :spree_prices, :contain_taxes, :boolean, default: false
  end
end
