class Material < ApplicationRecord
  has_many :recipe_materials
  has_many :recipes, through: :recipe_materials
end
