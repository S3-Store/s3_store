class CreatePriceLists < ActiveRecord::Migration[7.0]
  def change
    create_table :spree_price_lists do |t|
      t.string :name
      t.string :country_iso, limit: 2
      t.string :currency
      t.boolean :contain_taxes, default: false
      t.index ["country_iso"], name: "index_spree_price_lists_on_country_iso"
      t.timestamps
    end
  end
end
