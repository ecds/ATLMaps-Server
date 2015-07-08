class Api::V1::VectorLayersController < ApplicationController
  def index

  	@layers = VectorLayer.all.includes(:projects, :tags, :institution)

  	if params[:projectID]
    	render json: @layers, root: 'vector_layers', project_id: params[:projectID]
    else
    	render json: @layers, root: 'vector_layers', project_id: 0
    end

  end
  
  def show
    # if params[:project_id]
    #   foo = Projectlayer.where(layer_id: params[:id]).where( project_id: params[:project_id]).limit(1)
    #   foo.each do |marker|
    #     @marker = marker.marker
    #   end
    #   @layer = Layer.find(params[:id])
    # else
      layer = VectorLayer.find(params[:id])
    #end
    render json: layer, root: 'vector_layer' 
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
