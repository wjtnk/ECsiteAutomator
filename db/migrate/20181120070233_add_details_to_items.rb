class AddDetailsToItems < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :start_time, :datatime
    add_column :items, :min_interval, :integer
    add_column :items, :max_interval, :integer
    add_column :items, :random_exhibit, :boolean
  end
end
