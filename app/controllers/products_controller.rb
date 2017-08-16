class ProductsController < ApplicationController

  after_action :cors_set_access_control_headers

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, Authorization, Token'
    headers['Access-Control-Max-Age'] = "1728000"
  end

  def search
    keyword = params[:keyword]
    @products = Product.where("name LIKE ?", "%#{keyword}%")
    render json: @products.to_json(only: [:id, :name])
  end

  def show
    @product = Product.find(params[:id])
    render json: @product.to_json(only: [:id, :name, :image, :weight, :bundle, :price])
  end

end
