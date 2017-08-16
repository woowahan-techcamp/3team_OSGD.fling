class CreateRecipeProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :recipe_products do |t|
      t.references :recipe
      t.references :product
      t.timestamps
    end
  end
end
