class Product < ApplicationRecord
  belongs_to :material
  has_many :recipe_products
  has_many :recipes, through: :recipe_products

  def json
    return { :id => self.id, :name => self.name, :image => self.image,
             :weight => self.weight, :bundle => self.bundle, :price => self.price,
             :material_name => self.material.name, :material_id => self.material.id }
  end
end
