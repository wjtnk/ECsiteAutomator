class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.string :name
      t.text :content
      t.integer :count
      t.boolean :checked
      t.references :item, foreign_key: true

      t.timestamps
    end
  end
end
