require 'nokogiri'
require 'open-uri'

class RecipesController < ApplicationController
  def index
    @recipes = Recipe.last(6)
    render json: @recipes.to_json(only: [:title, :url, :image])
  end

  def create
    url = params[:url]
    if Recipe.where(url: url).present?
      @recipe = Recipe.where(url: url).first
      render json: @recipe.to_json(only: [:title, :url, :image])
    else data = Nokogiri::HTML(open(url))
      title = data.css('.view2_summary h3').text
      image = data.css('.centeredcrop img').attr('src')
      @recipe = Recipe.new(title: title, url: url, image: image)
      if @recipe.save!
        render json: @recipe.to_json(only: [:title, :url, :image])
      else
        render status: "unpermitted url"
      end
    end
  end

  def get_material(data)
  end
end
