class Api::V1::RasterLayerProjectsController < ApplicationController
  def index
    if params[:raster_layer_id]
      projectlayers = RasterLayerProject.where(raster_layer_id: params[:raster_layer_id]).where( project_id: params[:project_id])
    elsif params[:project_id]
      projectlayers = RasterLayerProject.where( project_id: params[:project_id])
    else
      projectlayers = RasterLayerProject.all
    end

    render json: projectlayers
  end

  def show
    if params[:raster_layer_id]
        @projectlayer = RasterLayerProject.where(raster_layer_id: params[:raster_layer_id]).where( project_id: params[:project_id])
    else
        @projectlayer = RasterLayerProject.find(params[:id])
    end

    render json: @projectlayer
  end

  def create
    projectlayer = RasterLayerProject.new(raster_layer_project_params)
    # Projects from the explore route have an ID of 9999999. We don't want to save that junk.
    # http://www.funnyordie.com/videos/4ecfd3a85f/herman-cains-campaign-promises-with-mike-tyson
    if current_resource_owner && raster_layer_project_params[:project_id] != '9999999'
      if projectlayer.save
        head 201
      end
    else
      head 401
    end
  end

  def update
    project = RasterLayerProject.find(params[:id])
    if project.update(raster_layer_project_params)
      head 201
    end
  end

  def destroy
    projectlayer = RasterLayerProject.find(params[:id])
    if mine(projectlayer.project) == true
      projectlayer.destroy
      head 204
    else
      head 401
    end
  end

  private
    def raster_layer_project_params
      params.require(:rasterLayerProject).permit(:project_id, :raster_layer_id, :layer_type, :position)
    end

end
