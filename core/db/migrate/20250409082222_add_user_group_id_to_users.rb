class AddUserGroupIdToUsers < ActiveRecord::Migration[7.0]
  def change
    change_table Spree.user_class.table_name do |t|
      t.references :user_group, foreign_key: { to_table: :spree_user_groups }
    end
  end
end
