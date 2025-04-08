class CreateUserGroups < ActiveRecord::Migration[7.2]
  def change
    create_table :spree_user_groups do |t|
      t.string :group_name
      t.references :price_list, foreign_key: { to_table: :spree_price_lists }

      t.timestamps
    end
  end
end
