class Api::V1::LayersController < ApplicationController
  
  def index
    #@layers = Layer.where(layer_type: 'geojson')
    @layers = Layer.all
    render json: @layers
  end
  
  def show
    @layer = Layer.find(params[:id])
    render json: @layer
    #respond_to do |format|
    #  format.json { render json: layer, status: :ok }
    #end
  end
  
  def update
    project = Project.find(params[:id])
    if project.update_attributes(params[:name])
      head 204, location: project
    end
  end
  
  #private
  #  def project_params
  #    params.permit(:project_ids => [])
  #  end
  
end

