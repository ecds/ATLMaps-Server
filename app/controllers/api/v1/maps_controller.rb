class Api::V1::MapsController < ApplicationController
    def index
        @layers = []
        rasters = params['maps'].split(',')
        puts "\n\n\n\n\n*****************"
        puts rasters
        puts "\n\n\n\n\n*****************"
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
