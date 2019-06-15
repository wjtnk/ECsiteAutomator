class AddAccessTimeToAccount < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :access_time, :datetime
  end
end
