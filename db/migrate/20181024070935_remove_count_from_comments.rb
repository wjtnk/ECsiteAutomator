class RemoveCountFromComments < ActiveRecord::Migration[5.2]
  def change
    remove_column :comments, :count, :integer
  end
end
