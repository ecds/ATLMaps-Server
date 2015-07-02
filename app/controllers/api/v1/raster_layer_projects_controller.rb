class Api::V1::RasterLayerProjectsController < ApplicationController
  def index
    if params[:raster_layer_id]
      projectlayers = RasterLayerProject.where(raster_layer_id: params[:raster_layer_id]).where( project_id: params[:project_id])
    elsif params[:project_id]
      projectlayers = RasterLayerProject.where( project_id: params[:project_id])
    else
      projectlayers = RasterLayerProject.all
    end
    puts projectlayers
    render json: projectlayers, root: 'raster_layer_projects'
  end
  
  def show
    @projectlayer = RasterLayerProject.find(params[:id])
    render json: @projectlayer, root: 'raster_layer_project'
  end

  def create
    projectlayer = RasterLayerProject.new(raster_layer_project_params)
    if projectlayer.save
      head 204
    end
  end
  
  def destroy
    projectlayer = RasterLayerProject.find(params[:id])
    projectlayer.destroy
    head 204
  end
  
  private
    def projectlayer_params
      params.require(:raster_layer_projectraster_layer_id).permit(:project_id, :raster_layer_id, :layer_type, :position)
    end
    
end
