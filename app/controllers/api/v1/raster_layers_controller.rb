class Api::V1::RasterLayersController < ApplicationController
	def index
		if params[:raster_layer]
			@layers = RasterLayer.where(layer: params[:layer])
		else
			@layers = RasterLayer.where(active: true).includes(:projects, :tags, :institution)
		end

		if params[:projectID]
			render json: @layers, root: 'raster_layers', project_id: params[:projectID]
		else
			render json: @layers, root: 'raster_layers', project_id: 0
		end
	end
  
	def show
		layer = RasterLayer.find(params[:id])
		render json: layer, root: 'raster_layer'
	end
  
  # def update
  #   project = Project.find(params[:id])
  #   if project.update_attributes(params[:name])
  #     head 204, location: project
  #   end
  # end
  
end
