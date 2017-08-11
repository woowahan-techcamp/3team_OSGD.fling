class CreateRecipes < ActiveRecord::Migration[5.0]
  def change
    create_table :recipes do |t|
      t.string :title
      t.string :url
      t.string :image
      t.string :writer
      t.string :subtitle
      t.timestamps
    end
  end
end
