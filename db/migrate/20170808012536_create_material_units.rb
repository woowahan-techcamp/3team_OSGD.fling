class CreateMaterialUnits < ActiveRecord::Migration[5.0]
  def change
    create_table :material_units do |t|
      t.references :material
      t.references :unit
      t.timestamps
    end
  end
end
