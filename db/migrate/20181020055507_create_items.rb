class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string :csv
      t.string :image1
      t.string :image2
      t.string :image3
      t.string :image4
      t.string :image5
      t.string :image6
      t.string :image7
      t.string :image8
      t.string :image9
      t.string :image10
      t.string :item_name
      t.text :description
      t.integer :category1
      t.integer :category2
      t.integer :category3
      t.integer :state
      t.integer :ship_fee
      t.integer :ship_method
      t.integer :ship_from
      t.integer :ship_day
      t.integer :purchase_application
      t.boolean :discount
      t.integer :price
      t.references :account, foreign_key: true

      t.timestamps
    end
  end
end
