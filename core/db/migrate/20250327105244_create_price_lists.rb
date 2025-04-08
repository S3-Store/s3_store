class CreatePriceLists < ActiveRecord::Migration[7.2]
  def change
    create_table :spree_price_lists do |t|
      t.string :name
      t.timestamps
    end
  end
end
