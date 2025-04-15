class CreatePriceListItems < ActiveRecord::Migration[7.0]
  def change
    create_table :spree_price_list_items do |t|
      t.references :price_list, foreign_key: { to_table: :spree_price_lists }
      t.references :price, type: :integer, foreign_key: { to_table: :spree_prices }
      t.timestamps
    end
  end
end
