class RecipeProduct < ApplicationRecord
  belongs_to :product
  belongs_to :recipe

  def self.create_with_products(recipe, products)
    products.each do |product|
      RecipeProduct.create(recipe_id: recipe.id, product_id: product.id)
    end
  end
end
