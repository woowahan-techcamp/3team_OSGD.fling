require 'csv'

class Material < ApplicationRecord
  has_many :recipe_materials
  has_many :recipes, through: :recipe_materials, source: :recipes
  has_many :material_units
  has_many :units, through: :material_units

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |product|
        csv << product.attributes.values_at("name")
        product.units.each do |unit|
           csv << unit.name
        end
      end
    end
  end

end
