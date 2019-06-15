class AddMaxAccountToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :max_account, :integer
  end
end
