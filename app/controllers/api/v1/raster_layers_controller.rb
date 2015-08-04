class Api::V1::RasterLayersController < ApplicationController
	def index
		if params[:raster_layer]
			@layers = RasterLayer.where(layer: params[:layer])
		else
			@layers = RasterLayer.where(active: true).includes(:projects, :tags, :institution)
		end

		# If there is a param of `projectID` were going to send that as an argument to 
		# the serializer.
		if params[:projectID]
			render json: @layers, root: 'raster_layers', project_id: params[:projectID]
		# Otherwise, we're just going to say that the `project_id` is `0` so the 
		# `active_in_project` attribute will be `false`.
		else
			render json: @layers, root: 'raster_layers', project_id: 0
		end
	end
  
	def show
		layer = RasterLayer.find(params[:id])
		if params[:projectID]
			render json: layer, root: 'raster_layer', project_id: params[:projectID]
		else
			render json: layer, root: 'raster_layer'
		end
	end
  
end
