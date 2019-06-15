class AddDetailsToAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :start_time, :datatime
    add_column :accounts, :min_interval, :integer
    add_column :accounts, :max_interval, :integer
    add_column :accounts, :random_exhibit, :boolean
  end
end
