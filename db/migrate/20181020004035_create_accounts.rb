class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.string :account_email
      t.string :account_password

      t.timestamps
    end
  end
end
