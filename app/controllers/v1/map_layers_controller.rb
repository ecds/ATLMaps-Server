class V1::MapLayersController < ApplicationController
    def index
        @layers = {}
        @layers[:raster_layer_ids] = []
        @layers[:vector_layer_ids] = []
        params['maps'].split(',').each do |r|
            @layers[:raster_layer_ids] << RasterLayer.where(name: r).first.id
        end
        data = params['data'].split(',')
        data.each do |v|
            @layers[:vector_layer_ids] << VectorLayer.where(name: v).first.id
        end
        render json: @layers, root: 'layers'
    end
end
