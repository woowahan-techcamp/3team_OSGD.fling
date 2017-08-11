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
    render json: @recipes.to_json(only: [:id, :title, :url, :image])
  end

  def get_products
    #recipe_id = params[:id]
    @products = Product.new
    if Product.count > 5
      @products = Product.last(4)
    end
    render json: @products.to_json(only: [:id, :name, :image, :weight, :bundle, :price])
  end

  #search and create Recipe
  def create
    url = params[:url]
    if Recipe.where(url: url).present?
      @recipe = Recipe.where(url: url).first
      render json: @recipe.to_json(only: [:id, :subtitle, :writer, :title, :url, :image])
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
          subtitle = data.css('div.aside h1').text.gsub(title, "").strip + " " + title
        else
          subtitle = ""
        end
        if data.css('strong.best a').present?
          writer = data.css('strong.best a').text
        else
          writer = ""
        end
        if title.length != 0
          @recipe = Recipe.create(title: title, subtitle: subtitle,
                                  url: url, image: image, writer: writer)
          render json: @recipe.to_json(only: [:id, :subtitle, :writer, :title, :url, :image])
        else
          render status: "unpermitted url"
        end
      else
        render status: "unpermitted url"
      end
    end
  end

  private
  def render_json_recipe(recipe)
    render json: recipe.to_json(only: [:id, :subtitle, :writer, :title, :url, :image])
  end
  def render_unpermitted_url
    render status: "unpermitted url"
  end
end
