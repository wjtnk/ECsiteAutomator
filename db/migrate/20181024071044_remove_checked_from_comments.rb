class RemoveCheckedFromComments < ActiveRecord::Migration[5.2]
  def change
    remove_column :comments, :checked, :boolean
  end
end
