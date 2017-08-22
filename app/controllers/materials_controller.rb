class MaterialsController < ApplicationController
  def show
    @material = Material.find(params[:id])
    puts @material
    render json: @material.to_json(only: [:name])
  end
end
