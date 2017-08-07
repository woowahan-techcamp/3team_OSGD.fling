require 'nokogiri'
require 'open-uri'
require 'json'

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
    else
      data = Nokogiri::HTML(open(url))
      title = data.css('.view2_summary h3').text
      image = data.css('.centeredcrop img').attr('src')
      @material = get_material(data)
      @recipe = Recipe.new(title: title, url: url, image: image)
      if @recipe.save!
        render json: {"recipe" : @recipe.to_json(only: [:title, :url, :image]),
                      "materials" : @material.to_json
                     }
      else
        render status: "unpermitted url"
      end
    end
  end

  def get_material(input)
    material = Hash.new()
    case1 = input.css('div.ready_ingre3 ul').count
    case2 = input.css('div.cont_ingre').count
    if case1 > 0
      material = case1(input)
    elsif case2 > 0
      material = case2(input)
    end
    return material

    ## 1 ul li 형식일때
    def case1(input)
      material = Hash.new()
      input.css('div.ready_ingre3 ul').each do |u|
        title = u.css('b').text
        if title == "[재료]" || title == "[양념]" || title == "[소스]"
          u.css('li').each do |li|
            name = li.text.split("  ")[0]
            unit = li.css('span.ingre_unit').text
            material[name] = unit
          end
        end
      end
      return material
    end
    ## 2 ul li가 아니라 dl일때 !! 문제점이 있다!
    def case2(input)
      material = Hash.new()
      input.css('div.cont_ingre dl').each do |dl|
        dl.css('dd').text.split(',').each do |m|
          title = m.split(' ').first
          unit = m.split(' ').last
          material[title] = unit
        end
      end
      return material
    end
  end

end
