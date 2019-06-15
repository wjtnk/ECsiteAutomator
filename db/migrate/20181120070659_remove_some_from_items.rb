class RemoveSomeFromItems < ActiveRecord::Migration[5.2]
  def change
    remove_column :items, :start_time, :datatime
    remove_column :items, :min_interval, :integer
    remove_column :items, :max_interval, :integer
    remove_column :items, :random_exhibit, :boolean
  end
end
