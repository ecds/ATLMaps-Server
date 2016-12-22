# tags
class Api::V1::TagsController < ApplicationController
    def index
        @tags = Tag.all.order('name')
        render json: @tags
    end

    def show
        @tag = Tag.find(params[:id])
        render json: @tag
    end

    def tag_params
        params.permit(raster_layer_ids: [])
    end
end
