class AddCountCommentsToItem < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :count_comments, :integer
  end
end
