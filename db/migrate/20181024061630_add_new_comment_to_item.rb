class AddNewCommentToItem < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :new_comment, :boolean
  end
end
