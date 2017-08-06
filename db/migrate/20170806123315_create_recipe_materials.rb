class CreateRecipeMaterials < ActiveRecord::Migration[5.0]
  def change
    create_table :recipe_materials do |t|
      t.references :recipe
      t.references :material
      t.references :unit
      t.string :value
      t.timestamps
    end
  end
end
