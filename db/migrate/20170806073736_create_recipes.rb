class CreateRecipes < ActiveRecord::Migration[5.0]
  def change
    create_table :recipes do |t|
      t.string :title, null: false
      t.string :url, index: true
      t.string :image
      t.string :writer
      t.string :subtitle
      t.timestamps
    end
  end
end
