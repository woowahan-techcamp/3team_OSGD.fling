class Recipe < ApplicationRecord
  has_many :recipe_materials
  has_many :materials, through: :recipe_materials
end
