class ChangeColumnToUser < ActiveRecord::Migration[5.2]
    def up
      change_column :users, :admin_flg, :boolean, default: false
      change_column :users, :max_account, :integer, default: 0
      change_column :users, :user_flg, :boolean, default: true
    end

    def down
      change_column :users, :admin_flg, :boolean
      change_column :users, :max_account, :integer
      change_column :users, :user_flg, :boolean
    end
end
