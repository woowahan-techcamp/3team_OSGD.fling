require 'csv'

class Material < ApplicationRecord
  has_many :recipe_materials
  has_many :recipes, through: :recipe_materials
  has_many :material_units
  has_many :units, through: :material_units
  has_many :products
end
