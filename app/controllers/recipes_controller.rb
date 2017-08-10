require 'nokogiri'
require 'json'

require 'open-uri'
class RecipesController < ApplicationController

  after_filter :cors_set_access_control_headers

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
    @products = Product.new
    if Product.count > 5
      @products = Product.last(4)
    end
    render json: @products.to_json(only: [:id, :name, :image, :weight, :bundle, :price])
  end

  def create
    url = params[:url]
    if Recipe.where(url: url).present?
            @recipe = Recipe.where(url: url).first
      render json: @recipe.to_json(only: [:id, :title, :url, :image])
    else
      data = Nokogiri::HTML(open(url))
      if !data.nil?
        title = data.css('div.aside h1 strong').text
        image = data.css('ul.slides li img').first.attr('src')

        # for material
        #data.css("div.btm li").each do |li|
          #name = li.css('span').text.delete(' ')
          #un_unit = li.css('em').text.delete(' ')
          #unit = un_unit.split(/(?<=\d)(?=[ㄱ-ㅎ|가-힣|a-z|A-Z|])/).last
          #if !un_unit.nil? && !unit.nil?
            #name = name.split("(").first
            #unit = unit.split("(").first
            ##puts "#{title} #{name} >> #{unit}"
          #end
        #end

        @recipe = Recipe.new(title: title, url: url, image: image)
        if @recipe.save!
          render json: @recipe.to_json(only: [:id, :title, :url, :image])
        else
          render status: "unpermitted url"
        end
      else
        render status: "unpermitted url"
      end
    end
  end

end
