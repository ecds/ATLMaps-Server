class Api::V1::MapsController < ApplicationController
    def index
        @layers = []
        rasters = params['maps'].split(',')
        rasters.each do |r|
            @layers << RasterLayer.where(name: r).first
        end
        vectors = params['data'].split(',')
        vectors.each do |v|
            @layers << VectorLayer.where(name: v).first
        end
        render json: @layers, root: 'layers'
    end
end
