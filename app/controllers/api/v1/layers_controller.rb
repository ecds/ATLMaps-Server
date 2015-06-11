class Api::V1::LayersController < ApplicationController
  
  def index
    #@layers = Layer.where(layer_type: 'geojson')
    if params[:project_id]
      marker = Projectlayer.where(layer_id: params[:layer_id]).where( project_id: params[:project_id])
      puts marker[:marker]
      @layers = Layer.all
    else
      @layers = Layer.all.includes(:projectlayer, :tags, :institution)
      #@layers = Layer.all
    end
    render json: @layers, root: 'layers'
  end
  
  def show
    # if params[:project_id]
    #   foo = Projectlayer.where(layer_id: params[:id]).where( project_id: params[:project_id]).limit(1)
    #   foo.each do |marker|
    #     @marker = marker.marker
    #   end
    #   @layer = Layer.find(params[:id])
    # else
      layer = Layer.find(params[:id])
    #end
    render json: layer, root: 'layer'
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

