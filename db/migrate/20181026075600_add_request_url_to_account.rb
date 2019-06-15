class AddRequestUrlToAccount < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :request_url, :string
  end
end
