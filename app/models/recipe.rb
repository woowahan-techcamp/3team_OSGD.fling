class Recipe < ApplicationRecord
  has_many :recipe_materials
  has_many :recipe_products
  has_many :materials, through: :recipe_materials
  has_many :products, through: :recipe_products

  def makeJson
    return  {id: self.id, title: self.title, subtitle: self.subtitle, image: self.image,
             writer: self.writer, url: self.url, name: self.title }.as_json
  end
end
