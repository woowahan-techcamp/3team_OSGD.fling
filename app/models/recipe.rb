class Recipe < ApplicationRecord
  has_many :recipe_materials
  has_many :recipe_products
  has_many :materials, through: :recipe_materials
  has_many :products, through: :recipe_products
end
