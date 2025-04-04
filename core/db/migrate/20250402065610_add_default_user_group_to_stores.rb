class AddDefaultUserGroupToStores < ActiveRecord::Migration[7.2]
  def change
    change_table :spree_stores do |t|
      t.references :default_user_group, type: :integer, foreign_key: { to_table: :spree_user_groups }
    end
  end
end
