class AddPriceListToUserGroup < ActiveRecord::Migration[7.0]
  def change
    change_table :spree_user_groups do |t|
      t.references :price_list, foreign_key: { to_table: :spree_price_lists }
    end
  end
end
