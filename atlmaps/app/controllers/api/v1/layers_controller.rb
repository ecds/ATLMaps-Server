class Api::V1::LayersController < ApplicationController
  
  def index
    layers = Layer.all
    if slug = params[:slug]
      layers = layers.where(slug: slug)
    end
    respond_to do |format|
      format.json { render json: layers, status: :ok }
    end
  end
  
  def show
    layer = Layer.find(params[:id])
    respond_to do |format|
      format.json { render json: layer, status: :ok }
    end
  end
  
end
