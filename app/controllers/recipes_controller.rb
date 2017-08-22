require 'nokogiri'
require 'json'
require 'open-uri'

class RecipesController < ApplicationController

  after_action :cors_set_access_control_headers

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, Authorization, Token'
    headers['Access-Control-Max-Age'] = "1728000"
  end

  def  index
    @recipes = Recipe.last(6)
    render json: @recipes.to_json(only: [:id, :subtitle, :writer, :title, :url, :image])
  end

  def season
    if Recipe.all.count < 9
      render status: :no_content
    else
      @recipes = Recipe.first(9)
      render json: @recipes.to_json(only: [:id, :subtitle, :writer, :title, :url, :image])
    end

  end

  def get_products
    recipe_id = params[:id]
    products = Recipe.find(recipe_id).products
    @products = products.map do |p|
      { :id => p.id, :name => p.name, :image => p.image, :weight => p.weight, :bundle => p.bundle,
        :price => p.price, :material_name => p.material.name, :material_id => p.material.id }
    end
    render json: @products
  end

  def show
    @recipe = Recipe.find(params[:id])
    render json: @recipe.to_json(only: [:id, :subtitle, :writer,
                                        :title, :url, :image,
                                        :missed_material,
                                        :recipe_material, :serving])
  end

  #search and create Recipe
  def create
    url = params[:url]
    if url.include?("http://haemukja.com/recipes/")
      if Recipe.where(url: url).present?
        @recipe = Recipe.where(url: url).first
        render json: @recipe.to_json(only: [:id, :subtitle, :writer,
                                            :title, :url, :image,
                                            :missed_material,
                                            :recipe_material, :serving])
      else
        data = Nokogiri::HTML(open(url))
        if !data.nil?
          if data.css('div.aside h1 strong').present?
            title = data.css('div.aside h1 strong').text
          else
            title = ""
          end
          if data.css('ul.slides li img').first.present?
            image = data.css('ul.slides li img').first.attr('src')
          else
            image = ""
          end
          if data.css('div.aside h1').present?
            subtitle = data.css('div.aside h1').text.strip.chomp(title).strip
          else
            subtitle = ""
          end
          if data.css('strong.best a').present?
            writer = data.css('strong.best a').text
          else
            writer = "해먹남녀"
          end
          if data.css('div.dropdown').present?
            serving = data.css('div.dropdown').text.strip
          else
            serving = ""
          end
          recipe_materials = []
          data.css("div.btm li").each do |li|
            name = li.css('span').text.delete(' ')
            un_unit = li.css('em').text.delete(' ')
            name = name.split("(").first
            recipe_materials << name + " " +  un_unit
          end
          searched_products = search_products(recipe_materials)
          puts missed_materials = searched_products["missed_materials"].join(", ")
          product_list = searched_products["product_list"]
          puts recipe_materials_string = recipe_materials.join(", ")

          if title.length != 0
            @recipe = Recipe.create(title: title, subtitle: subtitle,
                                    url: url, image: image,
                                    writer: writer, serving: serving,
                                    recipe_material: recipe_materials_string,
                                    missed_material: missed_materials
                                   )
            RecipeProduct.create_with_products(@recipe, product_list)
            render json: @recipe.to_json(only: [:id, :subtitle, :writer,
                                                :title, :url, :image,
                                                :missed_material,
                                                :recipe_material, :serving])
          else
            render status: :no_content
          end
        else
          render status: :no_content
        end
      end
    else
      render status: :no_content
    end
  end


  def search
    keyword = params[:keyword]
    if keyword.length == 0
      render :nothing
    else
      @recipes = Recipe.where("title LIKE ?", "%#{keyword}%" )
      render json: @recipes.to_json(only: [:id, :title])
    end
  end

  private
  def render_json_recipe(recipe)
    render json: recipe.to_json(only: [:id, :subtitle, :writer, :title, :url, :image])
  end

  def render_unpermitted_url
    render status: "unpermitted url"
  end

  def search_products(recipe_materials)
    result = Hash.new
    missed_materials = []
    product_list = []
    recipe_materials.each do |material|
      name = material.split(" ").first
      products_searched = Material.where("name LIKE ?", "#{name}")
      if products_searched.count == 0
        products_searched = Material.where("name LIKE ?", "%#{name}%")
        if products_searched.count == 0
          missed_materials << material
        else
          if products_searched.last.products.count == 0
            missed_materials << material
          else
            product_list << products_searched.last.products.first
          end
        end
      else
        if products_searched.last.products.count == 0
          missed_materials << material
        else
          product_list << products_searched.last.products.first
        end
      end
    end
    result["product_list"] = product_list
    result["missed_materials"] = missed_materials
    return result
  end

end
