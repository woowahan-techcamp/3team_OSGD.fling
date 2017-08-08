class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.references :material
      t.string :name
      t.string :price
      t.string :weight
      t.string :bundle
      t.string :image
      t.timestamps
    end
  end
end
