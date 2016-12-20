class Api::V1::RasterLayerProjectsController < ApplicationController
  def index
    if (params[:raster_layer_id] && params[:project_id])
      projectlayers = RasterLayerProject.where(raster_layer_id: params[:raster_layer_id]).where( project_id: params[:project_id]).first
    elsif params[:project_id]
      projectlayers = RasterLayerProject.where( project_id: params[:project_id])
    else
      projectlayers = RasterLayerProject.all
    end

    render json: projectlayers#, include:['raster_layer']
  end

  def show
    if params[:raster_layer_id]
        @projectlayer = RasterLayerProject.where(raster_layer_id: params[:raster_layer_id]).where( project_id: params[:project_id]).first
    else
        @projectlayer = RasterLayerProject.find(params[:id])
    end

    render json: @projectlayer
  end

  # def create
  #   projectlayer = RasterLayerProject.new(raster_layer_project_params)
  #    if projectlayer.save
  #       render json: {}, status: 201
  #   else
  #     head 401
  #   end
  # end

  def create
    projectlayer = RasterLayerProject.new(raster_layer_project_params)
    if @current_login
      if projectlayer.save
        # Ember wants some JSON
        render json: projectlayer, status: 201
      else
        head 500
      end
    else
      head 401
    end
  end

  def update
    project = RasterLayerProject.find(params[:id])
    if mayedit(project.project) == true
        if project.update(raster_layer_project_params)
          head 204
        else
          head 500
        end
    else
        head 401
    end
  end

  def destroy
    projectlayer = RasterLayerProject.find(params[:id])
    if mine(projectlayer.project) == true
      projectlayer.destroy
      render json: {}, status: 200
    else
      head 401
    end
  end

  private
    def raster_layer_project_params
      params.require(:rasterLayerProject).permit(:project_id, :raster_layer_id, :data_format, :position)
    end

end
