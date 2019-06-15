class AddUserFlgToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :user_flg, :boolean
  end
end
