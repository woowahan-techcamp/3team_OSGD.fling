class MaterialsController < ApplicationController
  after_action :cors_set_access_control_headers

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, Authorization, Token'
    headers['Access-Control-Max-Age'] = "1728000"
  end

  def show
    @material = Material.find(params[:id])
    puts @material
    render json: @material.to_json(only: [:name])
  end

  def search
    keyword = params[:keyword]
    if keyword.length == 0
      render :nothing
    else
      @materials = Material.where("name LIKE ?", "%#{keyword}%" )
      render json: @materials.to_json(only: [:id, :name])
    end
  end
end
